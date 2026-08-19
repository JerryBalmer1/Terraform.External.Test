# Analysis: modules/multi_instance

Static analysis of the reusable multi-instance child module. Companion to [01-multi-instance.analysis.md](01-multi-instance.analysis.md).

## 1. Inventory

| File | Block type | Label | Meta-arguments |
|------|------------|-------|----------------|
| [variables.tf](../modules/multi_instance/variables.tf#L1) | `variable` | `name_prefix` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L6) | `variable` | `instances` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L19) | `variable` | `output_directory` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L24) | `variable` | `file_permission` | — |
| [variables.tf](../modules/multi_instance/variables.tf#L30) | `variable` | `labels` | — |
| [locals.tf](../modules/multi_instance/locals.tf#L1) | `locals` | — | — |
| [main.tf](../modules/multi_instance/main.tf#L5) | `resource` | `random_id.x` | `for_each = local.instance_configs` |
| [main.tf](../modules/multi_instance/main.tf#L18) | `resource` | `random_pet.x` | `for_each = local.instance_configs` |
| [main.tf](../modules/multi_instance/main.tf#L32) | `resource` | `local_file.x` | `for_each = local.instance_configs` |
| [outputs.tf](../modules/multi_instance/outputs.tf#L1) | `output` | `instance_count` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L6) | `output` | `instance_keys` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L11) | `output` | `instances` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L26) | `output` | `identity_ids` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L31) | `output` | `pet_names` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L36) | `output` | `artifact_paths` | — |
| [outputs.tf](../modules/multi_instance/outputs.tf#L41) | `output` | `labels` | — |
| [versions.tf](../modules/multi_instance/versions.tf#L1) | `terraform` | — | required_providers: random, local |
| [README.md](../modules/multi_instance/README.md) | docs | — | §5 module contract |

## 2. Data flow trace

| # | Variable | Path | Terminal |
|---|----------|------|----------|
| 1 | `var.name_prefix` | → `local.normalized_prefix` | `random_id.x.prefix`, `random_id.x.keepers.name_prefix` |
| 2 | `var.name_prefix` | → `local.normalized_prefix` | `random_pet.x.prefix`, `random_pet.x.keepers.name_prefix` |
| 3 | `var.name_prefix` | → `local.normalized_prefix` → `local.instance_configs[].filename` | `local_file.x.filename` |
| 4 | `var.name_prefix` | → `local.normalized_prefix` | `local_file.x.content` (`name_prefix` field) |
| 5 | `var.instances` | → `local.instance_configs` | `for_each` on `random_id.x`, `random_pet.x`, `local_file.x` |
| 6 | `var.instances[*].label` | → `coalesce(try(...), key)` → `local.instance_configs[].label` | `local_file.x.content`, output `instances` |
| 7 | `var.instances[*].pet_length` | → coalesce → `local.instance_configs[].pet_length` | `random_pet.x.length`, keepers |
| 8 | `var.instances[*].byte_length` | → coalesce → `local.instance_configs[].byte_length` | `random_id.x.byte_length`, keepers |
| 9 | `var.output_directory` | → `local.instance_configs[].filename` | `local_file.x.filename` |
| 10 | `var.file_permission` | direct | `local_file.x.file_permission` |
| 11 | `var.labels` | → `local.module_labels` | `local_file.x.content.labels`, output `labels` |
| 12 | `random_id.x[key].hex` | direct | `local_file.x.content`, outputs `instances`, `identity_ids` |
| 13 | `random_pet.x[key].id` | direct | `local_file.x.content`, outputs `instances`, `pet_names` |
| 14 | `local_file.x[key].filename` | direct | outputs `instances`, `artifact_paths` |
| 15 | `local_file.x[key].content_sha1` | direct | output `instances` |
| 16 | `local.instance_configs` | → `length(...)` | output `instance_count` |
| 17 | `local.instance_configs` | → `sort(keys(...))` | output `instance_keys` |

## 3. Coverage report (module-local contribution)

| §4 item | Status in this module | Location |
|---------|----------------------|----------|
| Complex `map(object)` variable | covered | [variables.tf](../modules/multi_instance/variables.tf#L6-L16) |
| `optional()` with/without defaults | covered | [variables.tf](../modules/multi_instance/variables.tf#L9-L11) |
| `for_each` on resource over map(object) | covered | [main.tf](../modules/multi_instance/main.tf#L5-L33) |
| Map/list-of-config driving for_each inside child | covered | `var.instances` → `local.instance_configs` → `for_each` |
| `for` expression producing a map | covered | [locals.tf](../modules/multi_instance/locals.tf#L13-L21); [outputs.tf](../modules/multi_instance/outputs.tf#L13-L28) |
| `merge()` | covered | [locals.tf](../modules/multi_instance/locals.tf#L4); [main.tf](../modules/multi_instance/main.tf#L44) |
| `coalesce()` / `try()` | covered | [locals.tf](../modules/multi_instance/locals.tf#L16-L18) |
| Type coercion number→string | covered | keepers `tostring(...)` [main.tf](../modules/multi_instance/main.tf#L14) |
| Output aggregating for_each resources | covered | [outputs.tf](../modules/multi_instance/outputs.tf#L11-L38) |
| Output referencing resource attributes | covered | all resource-backed outputs |
| All other §4 rows | not covered in this module alone | see fixture analysis gaps |

## 4. Expected graph (module interior, default keys `a`/`b` if used standalone)

When called with fixture defaults `alpha`/`bravo`/`charlie`:

### Expected nodes

- `random_id.x["alpha"]`, `random_id.x["bravo"]`, `random_id.x["charlie"]`
- `random_pet.x["alpha"]`, `random_pet.x["bravo"]`, `random_pet.x["charlie"]`
- `local_file.x["alpha"]`, `local_file.x["bravo"]`, `local_file.x["charlie"]`
- `var.name_prefix`, `var.instances`, `var.output_directory`, `var.file_permission`, `var.labels`
- `local.normalized_prefix`, `local.module_labels`, `local.instance_configs`, `local.instance_count`

### Expected edges

- `var.name_prefix` -> `local.normalized_prefix` (data)
- `var.labels` -> `local.module_labels` (data)
- `var.instances` -> `local.instance_configs` (data)
- `var.output_directory` -> `local.instance_configs` (data)
- `local.normalized_prefix` -> `local.instance_configs` (data)
- `local.instance_configs` -> `random_id.x[*]` (for_each)
- `local.instance_configs` -> `random_pet.x[*]` (for_each)
- `local.instance_configs` -> `local_file.x[*]` (for_each)
- `local.normalized_prefix` -> `random_id.x[*]` (prefix/keepers)
- `local.normalized_prefix` -> `random_pet.x[*]` (prefix/keepers)
- `random_id.x[key]` -> `local_file.x[key]` (data)
- `random_pet.x[key]` -> `local_file.x[key]` (data)
- `local.module_labels` -> `local_file.x[*]` (data)
- `var.file_permission` -> `local_file.x[*]` (data)

No `depends_on`-only edges.

## 5. Constraint check

| Constraint | Result | Notes |
|------------|--------|-------|
| §3.1 Provider allowlist | **pass** | `random`, `local` only in [versions.tf](../modules/multi_instance/versions.tf) |
| §3.2 Invoke-Build | n/a as child | Exercised via fixture root |
| §3.3 Zero-input | n/a as child | Required inputs `name_prefix`, `output_directory` supplied by fixture defaults |
| §3.4 Determinism | **pass** | Shape from `var.instances` keys only; `keepers` on random resources |
| §3.5 Self-containment | **pass** | Lives under `modules/`; no external module sources |

## 6. Gaps (module-specific)

| Gap | Proposal |
|-----|----------|
| `count` instead of/in addition to `for_each` | Sibling resource using `count = var.n` |
| `for_each` over `set(string)` | Accept `toset(var.names)` path |
| Empty `for_each` | Call site with `instances = {}` |
| Scalar "how many VMs" pattern | Alternate API `var.instance_count` + `count` |
| `dynamic` blocks | Not applicable to current resource types without stretching null_resource |

## Adjustments applied

- `keepers` on `random_id.x` and `random_pet.x` for stable identity across benign plan refreshes.
- Module `README.md` added per §5.
- Consumed from `fixtures/01-multi-instance` with `source = "../../modules/multi_instance"`.
