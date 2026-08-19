# AGENTS.md

## 1. What this repo is

This repository is a **Terraform fixture corpus**. It is not production infrastructure and will never be deployed to a cloud account.

Its sole purpose is to serve as a torture test for a downstream consumer: a PowerShell module that parses Terraform configuration and state and generates `.drawio` diagrams. Every file here exists to make that generator either work correctly or fail loudly.

**Design principle:** if a Terraform construct can confuse a diagram generator, this repo should contain a fixture that exercises it.

Do not optimize these fixtures for readability, realism, or best practice. Optimize them for *coverage of the Terraform language*.

---

## 2. Excluded paths — do not read, analyze, or modify

The following paths are **outside your scope entirely**. They are build and release tooling, maintained by hand, and unrelated to the Terraform fixtures.

```
./build
./.build.ps1
./.gitignore
./Release.ps1
```

Rules:

- **Do not modify them.** Not to fix a bug, not to add a file to `.gitignore`, not to "clean up," not as a side effect of another task.
- **Do not analyze them.** They are excluded from every inventory, coverage report, file count, and search result. Skip the entire `./build` directory tree recursively.
- **Do not read them** unless the operator explicitly names the path in the current request. Absent that, treat them as if they do not exist.
- **Do not propose changes to them.** If a task appears to require touching one of these paths, stop and say which path and why. Wait for an explicit instruction naming that path before proceeding.
- These exclusions apply to every command in §6, every glob, and every recursive walk. A response that reports on an excluded path is non-compliant.

**Exception — invoking is not reading.** You are required to *run* the Invoke-Build tasks defined in §3.2. Running `Invoke-Build Build` is expected and correct. Opening `.build.ps1` to inspect, debug, or modify how it works is not. If a task fails, report the failure output verbatim and stop; do not open the build script to diagnose it.

Paths are relative to the repository root. `./build` means the directory and everything under it.

---

## 3. Hard constraints

These are non-negotiable. A change that violates any of them is rejected regardless of how good the rest of it is.

### 3.1 Provider allowlist

Only providers that require **zero credentials and zero network side effects** may be used:

| Allowed | Purpose |
|---|---|
| `hashicorp/random` | Synthetic values, IDs, names, shuffles |
| `hashicorp/local` | File reads/writes for fake artifacts |
| `hashicorp/null` | `null_resource` for dependency edges and triggers |
| `hashicorp/time` | `time_static`, `time_sleep`, rotation semantics |
| `hashicorp/tls` | Self-signed keys/certs, sensitive value paths |
| `hashicorp/external` | Only if the called program is committed in-repo and cross-platform |

**Forbidden:** `azurerm`, `aws`, `google`, `kubernetes`, `helm`, `vault`, `http`, or anything else that authenticates, reads credentials from the environment, or makes an outbound request at plan/apply time.

No `backend` blocks. No `cloud` blocks. State stays local.

### 3.2 How to test that a module works — use Invoke-Build, never raw terraform

There is exactly one sanctioned way to check that a module or nested module runs end to end:

```powershell
Invoke-Build Build     # runs terraform init, apply -auto-approve, destroy -auto-approve
Invoke-Build Clean     # removes .terraform, state files, and other generated artifacts
```

Rules for running these:

1. **Never invoke `terraform` directly** for a lifecycle test — not `init`, not `apply`, not `destroy`. `Invoke-Build Build` covers all three. The only bare terraform commands permitted are the read-only `terraform fmt` and `terraform validate` (§7 rule 6).
2. **Always run `Invoke-Build Clean` afterward**, including when `Build` fails. Leaving state files or `.terraform` directories behind is a failed task.
3. **Run it once.** If `Build` fails, capture the output, run `Clean`, and report. Do not retry, do not retry with different arguments, do not start editing `.tf` files to make it pass unless the operator asks you to fix it.
4. **One at a time.** Do not run builds in parallel or across multiple fixtures simultaneously.
5. **Do not invent tasks.** `Build` and `Clean` are the only two you call. If you think another task is needed, say so and stop — do not go looking in the build script for one (see §2).
6. **Report actual output.** Paste the real stdout/stderr. Never claim a build passed without the output to show it.

### 3.3 Zero-input execution

Every variable in every root module **must have a `default`**. `Invoke-Build Build` must succeed from a clean clone with no `.tfvars`, no `-var` flags, and no environment variables.

If a fixture requires input to run, it is broken.

### 3.4 Determinism

Anything a diagram is asserted against must be stable across runs. Use `random_*` resources with `keepers` where reproducibility matters, and never make graph *shape* depend on a random value — only graph *content*.

### 3.5 Self-containment

Child modules live in-repo under `modules/`. No registry module sources, no git sources, no `../../..` escapes above the repo root.

---

## 4. Coverage matrix

This is the checklist. Every row must eventually be exercised by at least one fixture, and every analysis must report against this table.

### 4.1 Variable and local plumbing
- [ ] `var` passed straight into a module input
- [ ] `var` → `local` → module input
- [ ] `local` derived from another `local` (multi-hop chain, 3+ deep)
- [ ] String concatenation / `join()` / `format()` / `formatlist()` building a value from several vars
- [ ] Complex typed variables: `object({})`, `list(object({}))`, `map(object({}))`
- [ ] `optional()` attributes with and without defaults
- [ ] Type coercion (number → string in interpolation)
- [ ] A local consumed by both a resource *and* a nested module (fan-out from one node)

### 4.2 Conditional logic
- [ ] `count = var.enabled ? 1 : 0` on a **resource**
- [ ] `count = var.enabled ? 1 : 0` on a **module**
- [ ] Ternary inside a `local`
- [ ] Nested ternaries
- [ ] `try()`, `coalesce()`, `can()`, `lookup()` with defaults
- [ ] A module that is fully disabled (`count = 0`) but still referenced by outputs via splat
- [ ] A conditional that changes *which* module output feeds a downstream input

### 4.3 Multi-instance
- [ ] `count` on a resource
- [ ] `for_each` on a resource over a `set(string)`
- [ ] `for_each` on a resource over a `map(object)`
- [ ] `count` on a module
- [ ] `for_each` on a module
- [ ] The "how many VMs do you want" pattern: a scalar count var driving instance creation inside a child module
- [ ] The "list of names" pattern: a `list(string)` var driving `for_each` inside a child module
- [ ] `dynamic` blocks
- [ ] Nested `dynamic` blocks
- [ ] Empty `for_each` (`{}`) — module present, zero instances

### 4.4 Module composition
- [ ] Root → child (single level)
- [ ] Root → child → grandchild (nested, 3+ levels deep)
- [ ] Sibling modules where module A's output is module B's input
- [ ] Fan-out: one module output consumed by three or more downstream modules
- [ ] Fan-in: one module input assembled from three or more upstream module outputs
- [ ] The same module source instantiated twice under different names
- [ ] The same module source instantiated with `count` and with `for_each` in separate places
- [ ] Explicit `depends_on` between modules with no data dependency (invisible edge)
- [ ] `providers = {}` passthrough with a provider alias

### 4.5 Expressions
- [ ] `for` expression producing a list
- [ ] `for` expression producing a map
- [ ] `for` with an `if` filter
- [ ] Splat (`[*]`) on a `count` resource and on a `count` module
- [ ] `flatten()`, `merge()`, `zipmap()`, `setproduct()`
- [ ] Index access into a `for_each` module output map

### 4.6 Outputs
- [ ] Output referencing a resource attribute
- [ ] Output referencing a module output
- [ ] Output aggregating across a `count`/`for_each` module
- [ ] `sensitive = true` output, and a sensitive value threaded through a module boundary
- [ ] Output that is a complex object, consumed as a whole by another module

### 4.7 Known generator traps
- [ ] Resource and module with the same name in different scopes
- [ ] A variable name shadowing a local name
- [ ] Deeply nested reference: `module.a.module_b_output["key"][0].attr`
- [ ] Comments and heredocs containing text that looks like HCL
- [ ] `moved` blocks
- [ ] `lifecycle` with `create_before_destroy`, `ignore_changes`, `precondition`/`postcondition`

---

## 5. Layout convention

```
/modules/<module-name>/          # reusable child modules
    main.tf  variables.tf  outputs.tf  versions.tf  README.md
/fixtures/<NN>-<scenario>/       # runnable root configs, one scenario each
    main.tf  variables.tf  outputs.tf  versions.tf  README.md
/analysis/                       # generated analysis artifacts (see §6)
/AGENTS.md
```

Anything not listed above — including the §2 excluded paths — is out of scope.

Each fixture's `README.md` must contain exactly three headings:
- `## Exercises` — bullet list keyed to §4 checklist items
- `## Expected nodes` — the node list the diagram generator should produce
- `## Expected edges` — the edge list, in `source -> target (edge type)` form

---

## 6. Commands

These are the phrases the operator will use. Each one has a defined, bounded meaning. **All of them respect the §2 exclusions.**

### `analyze module <path>`

**Read-only.** Do not create, edit, or delete any `.tf` file during an analyze. Do not run `Invoke-Build` during an analyze — analysis is static. If the analysis reveals needed changes, list them as recommendations and stop.

Produce the artifact `analysis/<name>.analysis.md` containing, in this order:

1. **Inventory** — table of every block: file, block type, label, meta-arguments (`count`/`for_each`/`depends_on`/`provider`).
2. **Data flow trace** — for every input variable, the complete path from declaration through locals and expressions to each terminal consumer (resource attribute, module input, or output). One row per distinct path. If a variable forks, every fork gets its own row.
3. **Coverage report** — the full §4 checklist, each row marked `covered` / `not covered`, with the file and line for each covered row. Do not omit rows to shorten the table.
4. **Expected graph** — node list and edge list, matching the README format in §5. Mark edges that exist only via `depends_on` as `implicit`.
5. **Constraint check** — pass/fail on each of §3.1 through §3.5, with the specific violation quoted if failed.
6. **Gaps** — checklist rows not covered anywhere in the repo, with a one-line proposal for a fixture that would cover each.

### `verify`

For each fixture, run `Invoke-Build Build` then `Invoke-Build Clean`, one fixture at a time, per the rules in §3.2. Write results to `analysis/verification.md`: one row per fixture, `pass`/`fail`, plus captured stderr for any failure. Do not summarize failures as "some fixtures failed" — name them. Do not attempt fixes as part of `verify`; verify reports, it does not repair.

### `add coverage <checklist item>`

Create or extend the minimum number of fixtures needed to cover the named item. Run `Invoke-Build Build` and `Invoke-Build Clean` on what you touched. Then re-run `analyze module` on every touched path and update the affected READMEs. Report which checklist rows flipped from `not covered` to `covered`.

---

## 7. Operating rules

1. **Respect §2 exclusions on every operation.** Excluded paths are invisible unless the operator names one explicitly.
2. **Ask before inventing scope.** If a request is ambiguous, state the two most likely readings and ask which. Do not pick one silently.
3. **No unrequested refactors.** Touch only what the task requires.
4. **Never weaken a constraint to make a task easier.** If a task appears to require a forbidden provider or a variable without a default, stop and say so.
5. **Every claim about the code cites a file and line.** No summaries from memory.
6. **Run `terraform fmt` and `terraform validate` on anything written before reporting done.** These two are read-only and always permitted. Any lifecycle test goes through `Invoke-Build Build` per §3.2.
7. **Leave the working tree clean.** `Invoke-Build Clean` has run, no state files, no `.terraform` directories, no stray artifacts.
8. **Nothing is done until the artifact exists on disk.** A response describing an analysis is not an analysis.

---

## 8. Lessons learned

**Protocol — this is mandatory and produces a visible artifact:**

- Before starting any task, read this section. The **first line** of your response must be `Lessons applied: L-001, L-004` naming every entry that bears on the task, or `Lessons applied: none`. A response missing this line is non-compliant.
- When a mistake is caught — by the operator or by you — append a new numbered entry here **in the same turn**, before doing anything else.
- Entries are append-only. Never delete, reword, or renumber an existing entry. If an entry becomes wrong, add a new one that supersedes it and note the number it supersedes.

**Format:**

```
### L-NNN — YYYY-MM-DD — <short title>
**Trigger:** what was being attempted
**Mistake:** what went wrong, concretely
**Rule:** the imperative to follow from now on
**Supersedes:** L-NNN (omit if none)
```

---

### L-001 — 2026-08-18 — Seed entry
**Trigger:** Repository initialization.
**Mistake:** None; this entry establishes the format.
**Rule:** Every subsequent entry follows the format above exactly. The `Lessons applied:` line is required on every response in this repository.

### L-002 — 2026-08-18 — Follow AGENTS protocol before editing fixtures
**Trigger:** Prior turns added `modules/multi_instance`, rewrote root README, and ran raw `terraform init/apply` while AGENTS.md already defined layout, analyze, and lifecycle rules.
**Mistake:** Skipped `Lessons applied:`; used raw terraform lifecycle commands instead of `Invoke-Build Build`/`Clean`; left runnable root `.tf` outside `/fixtures/`; omitted module/fixture README contract and `analysis/` artifacts; treated the repo like a consumer demo instead of a fixture corpus.
**Rule:** On every task, apply §8 first; keep runnable roots only under `/fixtures/<NN>-<scenario>/`; put reusable children only under `/modules/<name>/` with the §5 file set; write `analysis/<name>.analysis.md` for analyze; use `Invoke-Build Build` then `Invoke-Build Clean` for lifecycle proof; never use raw `terraform init/apply/destroy`.
### L-003 — 2026-08-18 — Root Invoke-Build does not apply fixtures after layout move
**Trigger:** After moving runnable roots into `fixtures/01-multi-instance/`, ran `Invoke-Build Build` from repo root (and from the fixture directory).
**Mistake:** Assumed Build would exercise the fixture. Actual Apply stderr was `Error: No configuration files` while the task still exited 0 ("Build succeeded"). Lifecycle never applied the fixture; only root-level empty init ran. Diagnosing or fixing requires `.build.ps1` (excluded §2).
**Rule:** After any layout change, treat `Invoke-Build Build` stdout/stderr as authoritative — a zero exit is not proof the fixture applied. If Apply reports no configuration files, stop and report that the excluded build entrypoint still targets the repo root; do not open or edit `.build.ps1` unless the operator explicitly names that path. Do not claim fixture lifecycle pass without apply creating the expected resources.
