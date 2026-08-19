# Analysis: fixtures/01-multi-instance

Static analysis of the multi-instance fixture and its nested modules. Generated per AGENTS.md §6 `analyze module`.

## 1. Inventory

### fixtures/01-multi-instance

| File | Block type | Label | Meta-arguments |
|------|------------|-------|----------------|
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L1) | `variable` | `project_name` | — |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L7) | `variable` | `environment` | — |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L13) | `variable` | `name_separator` | — |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L19) | `variable` | `identity_byte_length` | validation |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L30) | `variable` | `content_body` | — |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L36) | `variable` | `output_directory` | — |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L42) | `variable` | `enable_bundle_marker` | — |
| [variables.tf](../fixtures/01-multi-instance/variables.tf#L48) | `variable` | `multi_instances` | — |
| [locals.tf](../fixtures/01-multi-instance/locals.tf#L1) | `locals` | (root) | — |
| [main.tf](../fixtures/01-multi-instance/main.tf#L1) | `module` | `basic_identity` | — |
| [main.tf](../fixtures/01-multi-instance/main.tf#L9) | `module` | `basic_content` | — |
| [main.tf](../fixtures/01-multi-instance/main.tf#L22) | `module` | `multi_instance` | — |
| [main.tf](../fixtures/01-multi-instance/main.tf#L31) | `resource` | `null_resource.bundle_marker` | `count` |
| [main.tf](../fixtures/01-multi-instance/main.tf#L41) | `resource` | `local_file.root_summary` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L1) | `output` | `name_prefix` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L6) | `output` | `identity_id` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L11) | `output` | `identity_name` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L16) | `output` | `content_path` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L21) | `output` | `content_sha1` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L26) | `output` | `metadata_path` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L31) | `output` | `summary_path` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L36) | `output` | `bundle_marker_id` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L41) | `output` | `common_labels` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L46) | `output` | `multi_instance_count` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L51) | `output` | `multi_instance_keys` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L56) | `output` | `multi_instances` | — |
| [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L61) | `output` | `multi_identity_ids` | — |
| [versions.tf](../fixtures/01-multi-instance/versions.tf#L1) | `terraform` | — | required_providers |
| [versions.tf](../fixtures/01-multi-instance/versions.tf#L20) | `provider` | `random` | — |
| [versions.tf](../fixtures/01-multi-instance/versions.tf#L22) | `provider` | `local` | — |
| [versions.tf](../fixtures/01-multi-instance/versions.tf#L24) | `provider` | `null` | — |

### modules/multi_instance

| File | Block type | Label | Meta-arguments |
|------|------------|-------|----------------|
| [variables.tf](../modules/multi_instance/variables.tf#L1) | `variable` | `name_prefix` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L6) | `variable` | `instances` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L19) | `variable` | `output_directory` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L24) | `variable` | `file_permission` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L30) | `variable` | `labels` | — |
| [locals.tf](../modules/multi_instance/locals.tf#L1) | `locals` | (module) | — |
| [main.tf](../modules/multi_instance/main.tf#L5) | `resource` | `random_id.x` | `for_each` |
| [main.tf](../modules/multi_instance/main.tf#L18) | `resource` | `random_pet.x` | `for_each` |
| [main.tf](../modules/multi_instance/main.tf#L32) | `resource` | `local_file.x` | `for_each` |
| [outputs.tf](../modules/multi_instance/outputs.tf#L1) | `output` | `instance_count` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L6) | `output` | `instance_keys` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L11) | `output` | `instances` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L26) | `output` | `identity_ids` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L31) | `output` | `pet_names` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L36) | `output` | `artifact_paths` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L41) | `output` | `labels` | — |
| [versions.tf](../modules/multi_instance/versions.tf#L1) | `terraform` | — | required_providers |

### modules/basic_identity

| File | Block type | Label | Meta-arguments |
|------|------------|-------|----------------|
| [variables.tf](../modules/basic_identity/variables.tf#L1) | `variable` | `name_prefix` | — |
| [variables.tf](../modules/basic_identity/variables.tf#L6) | `variable` | `byte_length` | — |
| [variables.tf](../modules/basic_identity/variables.tf#L12) | `variable` | `pet_length` | — |
| [variables.tf](../modules/basic_identity/variables.tf#L18) | `variable` | `string_length` | — |
| [variables.tf](../modules/basic_identity/variables.tf#L24) | `variable` | `labels` | — |
| [locals.tf](../modules/basic_identity/locals.tf#L1) | `locals` | (module) | — |
| [main.tf](../modules/basic_identity/main.tf#L1) | `resource` | `random_id.this` | — |
| [main.tf](../modules/basic_identity/main.tf#L11) | `resource` | `random_pet.this` | — |
| [main.tf](../modules/basic_identity/main.tf#L22) | `resource` | `random_string.suffix` | — |
| [outputs.tf](../modules/basic_identity/outputs.tf#L1) | `output` | `identity_id` | — |
| [outputs.tf](../modules/basic_identity/outputs.tf#L6) | `output` | `identity_b64` | — |
| [outputs.tf](../modules/basic_identity/outputs.tf#L11) | `output` | `pet_name` | — |
| [outputs.tf](../modules/basic_identity/outputs.tf#L16) | `output` | `suffix` | — |
| [outputs.tf](../modules/basic_identity/outputs.tf#L21) | `output` | `composed_name` | — |
| [outputs.tf](../modules/basic_identity/outputs.tf#L26) | `output` | `labels` | — |
| [versions.tf](../modules/basic_identity/versions.tf#L1) | `terraform` | — | required_providers |

### modules/basic_content

| File | Block type | Label | Meta-arguments |
|------|------------|-------|----------------|
| [variables.tf](../modules/basic_content/variables.tf#L1) | `variable` | `name_prefix` | — |
| [variables.tf](../modules/basic_content/variables.tf#L6) | `variable` | `identity_id` | — |
| [variables.tf](../modules/basic_content/variables.tf#L11) | `variable` | `identity_name` | — |
| [variables.tf](../modules/basic_content/variables.tf#L16) | `variable` | `content_body` | — |
| [variables.tf](../modules/basic_content/variables.tf#L21) | `variable` | `content_filename` | — |
| [variables.tf](../modules/basic_content/variables.tf#L26) | `variable` | `metadata_filename` | — |
| [variables.tf](../modules/basic_content/variables.tf#L31) | `variable` | `file_permission` | — |
| [variables.tf](../modules/basic_content/variables.tf#L37) | `variable` | `labels` | — |
| [locals.tf](../modules/basic_content/locals.tf#L1) | `locals` | (module) | — |
| [main.tf](../modules/basic_content/main.tf#L1) | `resource` | `local_file.content` | — |
| [main.tf](../modules/basic_content/main.tf#L7) | `resource` | `local_file.metadata` | — |
| [outputs.tf](../modules/basic_content/outputs.tf#L1) | `output` | `content_path` | — |
| [outputs.tf](../modules/basic_content/outputs.tf#L6) | `output` | `content_sha1` | — |
| [outputs.tf](../modules/basic_content/outputs.tf#L11) | `output` | `metadata_path` | — |
| [outputs.tf](../modules/basic_content/outputs.tf#L16) | `output` | `metadata_sha1` | — |
| [outputs.tf](../modules/basic_content/outputs.tf#L21) | `output` | `labels` | — |
| [versions.tf](../modules/basic_content/versions.tf#L1) | `terraform` | — | required_providers |

## 2. Data flow trace

| # | Source | Path | Terminal consumer |
|---|--------|------|-------------------|
| 1 | `var.project_name` | → `local.name_prefix` | `module.basic_identity.name_prefix` |
| 2 | `var.project_name` | → `local.name_prefix` | `module.basic_content.name_prefix` |
| 3 | `var.project_name` | → `local.name_prefix` | `module.multi_instance.name_prefix` |
| 4 | `var.project_name` | → `local.name_prefix` | `local.content_filename` / `local.metadata_filename` / `local.multi_output_dir` |
| 5 | `var.project_name` | → `local.name_prefix` | `local_file.root_summary` filename + content |
| 6 | `var.project_name` | → `local.common_labels` | module `labels` inputs; `local_file.root_summary` |
| 7 | `var.environment` | → `local.name_prefix` | same terminals as rows 1–5 |
| 8 | `var.environment` | → `local.common_labels` | same as row 6 |
| 9 | `var.name_separator` | → `local.name_prefix` | same terminals as rows 1–5 |
| 10 | `var.identity_byte_length` | direct | `module.basic_identity.byte_length` → `random_id.this.byte_length` |
| 11 | `var.content_body` | direct | `module.basic_content.content_body` → `local.rendered_content` → `local_file.content` |
| 12 | `var.output_directory` | → `local.content_filename` | `module.basic_content.content_filename` |
| 13 | `var.output_directory` | → `local.metadata_filename` | `module.basic_content.metadata_filename` |
| 14 | `var.output_directory` | → `local.multi_output_dir` | `module.multi_instance.output_directory` |
| 15 | `var.output_directory` | direct in expression | `local_file.root_summary.filename` |
| 16 | `var.enable_bundle_marker` | direct | `null_resource.bundle_marker` `count` |
| 17 | `var.enable_bundle_marker` | direct | `local_file.root_summary` content field `bundle_enabled` |
| 18 | `var.multi_instances` | direct | `module.multi_instance.instances` → `local.instance_configs` → `for_each` on `random_id.x` / `random_pet.x` / `local_file.x` |
| 19 | `module.basic_identity.identity_id` | sibling | `module.basic_content.identity_id` |
| 20 | `module.basic_identity.pet_name` | sibling | `module.basic_content.identity_name` |
| 21 | `module.basic_identity.identity_id` | → `local.bundle_trigger` | `null_resource.bundle_marker.triggers` |
| 22 | `module.basic_identity.pet_name` | → `local.bundle_trigger` | `null_resource.bundle_marker.triggers` |
| 23 | `module.basic_content.content_sha1` | → `local.bundle_trigger` | `null_resource.bundle_marker.triggers` |
| 24 | `module.multi_instance.instance_count` | → `tostring(...)` → `local.bundle_trigger` | `null_resource.bundle_marker.triggers` |
| 25 | `module.multi_instance.instance_count` | direct | `local_file.root_summary` / output `multi_instance_count` |
| 26 | `module.multi_instance.instance_keys` | direct | `local_file.root_summary` / output `multi_instance_keys` |
| 27 | `module.multi_instance.identity_ids` | direct | `local_file.root_summary` / output `multi_identity_ids` |
| 28 | `module.multi_instance.instances` | direct | output `multi_instances` |
| 29 | `null_resource.bundle_marker[0].id` | `try(..., null)` | output `bundle_marker_id` |
| 30 | `local_file.root_summary.filename` | direct | output `summary_path` |

### multi_instance internal (child)

| # | Source | Path | Terminal |
|---|--------|------|----------|
| M1 | `var.name_prefix` | → `local.normalized_prefix` | `random_id.x` prefix/keepers; `random_pet.x` prefix/keepers; `local_file.x` content; filenames via `local.instance_configs` |
| M2 | `var.instances` | → `local.instance_configs` | `for_each` on all three resources; output maps |
| M3 | `var.output_directory` | → `local.instance_configs.filename` | `local_file.x.filename` |
| M4 | `var.file_permission` | direct | `local_file.x.file_permission` |
| M5 | `var.labels` | → `local.module_labels` | `local_file.x` content labels; output `labels` |
| M6 | `random_id.x[key].hex` | direct | `local_file.x` content; outputs `instances` / `identity_ids` |
| M7 | `random_pet.x[key].id` | direct | `local_file.x` content; outputs `instances` / `pet_names` |

## 3. Coverage report

Full §4 checklist for this fixture/module set. Rows marked `covered` cite file and line in this corpus.

### 4.1 Variable and local plumbing

| Item | Status | Location |
|------|--------|----------|
| `var` passed straight into a module input | covered | [fixtures/01-multi-instance/main.tf](../fixtures/01-multi-instance/main.tf#L5) `byte_length = var.identity_byte_length`; L15 `content_body`; L26 `instances = var.multi_instances` |
| `var` → `local` → module input | covered | [locals.tf](../fixtures/01-multi-instance/locals.tf#L2-L5) → [main.tf](../fixtures/01-multi-instance/main.tf#L4) `name_prefix` |
| `local` derived from another `local` (3+ deep) | not covered | — |
| String concatenation / `join()` / `format()` / `formatlist()` | covered | [locals.tf](../fixtures/01-multi-instance/locals.tf#L2) `join`; [modules/basic_identity/locals.tf](../modules/basic_identity/locals.tf#L12) `join` |
| Complex typed variables: `object` / `list(object)` / `map(object)` | covered | [variables.tf](../fixtures/01-multi-instance/variables.tf#L48-L59) `map(object)`; child [modules/multi_instance/variables.tf](../modules/multi_instance/variables.tf#L6-L16) |
| `optional()` attributes with and without defaults | covered | [variables.tf](../fixtures/01-multi-instance/variables.tf#L51-L53) `optional(string)` no default; `optional(number, 2)` with default |
| Type coercion (number → string) | covered | [locals.tf](../fixtures/01-multi-instance/locals.tf#L22) `tostring(module.multi_instance.instance_count)`; keepers in multi_instance/basic_identity |
| Local consumed by resource *and* nested module | covered | `local.name_prefix` → modules ([main.tf](../fixtures/01-multi-instance/main.tf#L4)) and `local_file.root_summary` ([main.tf](../fixtures/01-multi-instance/main.tf#L42-L45)) |

### 4.2 Conditional logic

| Item | Status | Location |
|------|--------|----------|
| `count = var.enabled ? 1 : 0` on resource | covered | [main.tf](../fixtures/01-multi-instance/main.tf#L32) |
| `count = var.enabled ? 1 : 0` on module | not covered | — |
| Ternary inside a `local` | not covered | — |
| Nested ternaries | not covered | — |
| `try()`, `coalesce()`, `can()`, `lookup()` with defaults | covered | [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L38) `try`; [modules/multi_instance/locals.tf](../modules/multi_instance/locals.tf#L16-L18) `coalesce`/`try` |
| Module fully disabled (`count = 0`) still referenced via splat | not covered | — |
| Conditional that changes which module output feeds downstream | not covered | — |

### 4.3 Multi-instance

| Item | Status | Location |
|------|--------|----------|
| `count` on a resource | covered | [main.tf](../fixtures/01-multi-instance/main.tf#L32) (conditional count; still count meta-arg) |
| `for_each` on a resource over a `set(string)` | not covered | — |
| `for_each` on a resource over a `map(object)` | covered | [modules/multi_instance/main.tf](../modules/multi_instance/main.tf#L5-L33) via `local.instance_configs` map |
| `count` on a module | not covered | — |
| `for_each` on a module | not covered | — |
| Scalar count var driving instances inside child | not covered | — |
| List/map of names driving `for_each` inside child | covered | root `multi_instances` → child `instances` → `for_each` |
| `dynamic` blocks | not covered | — |
| Nested `dynamic` blocks | not covered | — |
| Empty `for_each` (`{}`) | not covered | — |

### 4.4 Module composition

| Item | Status | Location |
|------|--------|----------|
| Root → child (single level) | covered | [main.tf](../fixtures/01-multi-instance/main.tf#L1-L29) |
| Root → child → grandchild (3+ levels) | not covered | — |
| Sibling modules A output → B input | covered | `basic_identity` → `basic_content` [main.tf](../fixtures/01-multi-instance/main.tf#L13-L14) |
| Fan-out: one module output → 3+ downstream modules | not covered | — |
| Fan-in: one input from 3+ upstream module outputs | not covered | — |
| Same module source twice under different names | not covered | — |
| Same source with `count` and `for_each` separately | not covered | — |
| Explicit `depends_on` between modules | not covered | — |
| `providers = {}` passthrough with alias | not covered | — |

### 4.5 Expressions

| Item | Status | Location |
|------|--------|----------|
| `for` expression producing a list | not covered | — |
| `for` expression producing a map | covered | [modules/multi_instance/locals.tf](../modules/multi_instance/locals.tf#L13-L21); [outputs.tf](../modules/multi_instance/outputs.tf#L13-L23) |
| `for` with an `if` filter | not covered | — |
| Splat (`[*]`) on count resource/module | not covered | — |
| `flatten()`, `merge()`, `zipmap()`, `setproduct()` | covered | `merge` in [modules/multi_instance/locals.tf](../modules/multi_instance/locals.tf#L4); [modules/basic_content/main.tf](../modules/basic_content/main.tf#L9) |
| Index access into a `for_each` module output map | not covered | (root passes whole maps; no `module.x["k"].attr` at root) |

### 4.6 Outputs

| Item | Status | Location |
|------|--------|----------|
| Output referencing a resource attribute | covered | [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L33) `local_file.root_summary.filename` |
| Output referencing a module output | covered | [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L6-L28) |
| Output aggregating across count/for_each module | covered | [outputs.tf](../fixtures/01-multi-instance/outputs.tf#L56-L63) multi maps; child aggregates for_each resources |
| `sensitive = true` output / sensitive through boundary | not covered | — |
| Complex object output consumed as whole by another module | not covered | — |

### 4.7 Known generator traps

| Item | Status | Location |
|------|--------|----------|
| Resource and module same name different scopes | not covered | — |
| Variable name shadowing a local name | not covered | — |
| Deeply nested reference `module.a...["key"][0].attr` | not covered | — |
| Comments/heredocs looking like HCL | partial | heredoc in [modules/basic_content/locals.tf](../modules/basic_content/locals.tf#L10-L16) (content, not HCL-looking trap) |
| `moved` blocks | not covered | — |
| `lifecycle` create_before_destroy / ignore_changes / pre/postcondition | not covered | — |

## 4. Expected graph

See fixture README sections **Expected nodes** and **Expected edges**:

- [fixtures/01-multi-instance/README.md](../fixtures/01-multi-instance/README.md)

No `depends_on`-only (implicit) edges in this fixture.

Default multi-instance keys: `alpha`, `bravo`, `charlie` ([variables.tf](../fixtures/01-multi-instance/variables.tf#L55-L59)).

## 5. Constraint check

| Constraint | Result | Notes |
|------------|--------|-------|
| §3.1 Provider allowlist | **pass** | Only `hashicorp/random`, `hashicorp/local`, `hashicorp/null`. No backend/cloud blocks. |
| §3.2 Invoke-Build lifecycle | **pass** | `Invoke-Build Build` applies each `fixtures/*` root (init/apply/destroy). Verified: Apply complete Resources: 16 added; Destroy complete Resources: 16 destroyed; Clean leaves fixture without state/`.terraform`. |
| §3.3 Zero-input execution | **pass** | Every root variable in [variables.tf](../fixtures/01-multi-instance/variables.tf) has a `default`. |
| §3.4 Determinism | **pass** (adjusted) | Graph shape keyed by stable `var.multi_instances` / `var.instances` keys only. `keepers` added on `random_*` in [modules/multi_instance/main.tf](../modules/multi_instance/main.tf) and [modules/basic_identity/main.tf](../modules/basic_identity/main.tf). Random values remain content, not shape. |
| §3.5 Self-containment | **pass** (adjusted) | Child sources are in-repo `../../modules/...` from fixture; no registry/git sources. |

## 6. Gaps

Checklist rows not covered anywhere in the repo yet, with one-line fixture proposals:

| Gap | Proposal |
|-----|----------|
| local multi-hop 3+ deep | Fixture `02-local-chain`: `local.a` → `local.b` → `local.c` → resource |
| count on module | Fixture `03-module-count`: `module "x" { count = var.n }` |
| for_each on module | Fixture `04-module-for-each`: `module "x" { for_each = var.map }` |
| for_each over set(string) | Extend multi_instance or new fixture with `toset([...])` |
| scalar count inside child ("how many VMs") | Child module with `count = var.instance_count` on a resource |
| empty for_each `{}` | Fixture with `for_each = {}` still declaring the module/resource |
| dynamic / nested dynamic | Fixture using `dynamic "setting"` blocks on a compatible resource or null_resource triggers via dynamic |
| root → child → grandchild | Fixture nesting multi_instance under an intermediate wrapper module |
| fan-out / fan-in module wiring | Three consumers of one output; one input merged from three modules |
| same module source twice; count+for_each same source | Two `module` blocks same `source` |
| depends_on-only edge | Sibling modules with `depends_on` and no data ref |
| providers passthrough alias | Root aliased provider + `providers = { random = random.alias }` |
| for list / for if / splat / zipmap / setproduct | Expression-heavy fixture |
| index into for_each module output | `module.x["k"].out` feeding another module |
| sensitive outputs | `sensitive = true` threaded child → root |
| complex object output whole-module consume | Pass entire object output as next module input |
| name shadowing / same resource+module names | Trap fixture with intentional collisions |
| deep nested reference | `module.a.out["k"][0].attr` |
| HCL-looking comments/heredocs | Heredoc containing `resource "x" "y" {}` text |
| moved blocks | `moved { from = ... to = ... }` |
| lifecycle pre/postcondition / ignore_changes | Resource with lifecycle block |

## Adjustments made during this analysis pass

1. Moved runnable root from repo root into `fixtures/01-multi-instance/` (§5 layout).
2. Fixed module `source` paths to `../../modules/...`.
3. Added missing `README.md` on all three child modules and the fixture (§5 contract).
4. Added `keepers` on `random_*` for determinism posture (§3.4).
5. Wrote this analysis artifact (§6 / §7.8).
6. Recorded L-002 for prior AGENTS protocol violations.
