# multi_instance

Reusable child module that creates **more than one instance of X** via `for_each` over a `map(object)`.

## Purpose

Fixture building block for diagram-generator coverage of multi-instance resource expansion inside a nested module. Graph *shape* is determined only by `var.instances` keys; `random_*` values affect content only.

## Resources (per instance key)

| Address | Role |
|---------|------|
| `random_id.x[key]` | Hex identity |
| `random_pet.x[key]` | Pet name |
| `local_file.x[key]` | JSON artifact |

## Inputs

| Name | Type | Required | Default |
|------|------|----------|---------|
| `name_prefix` | `string` | yes | — |
| `instances` | `map(object)` | no | `a`, `b` |
| `output_directory` | `string` | yes | — |
| `file_permission` | `string` | no | `0644` |
| `labels` | `map(string)` | no | `{}` |

`instances` object attributes: `label` (optional), `pet_length` (optional, default 2), `byte_length` (optional, default 4).

## Outputs

| Name | Description |
|------|-------------|
| `instance_count` | Number of X instances |
| `instance_keys` | Sorted keys |
| `instances` | Full detail map |
| `identity_ids` | Key → hex id |
| `pet_names` | Key → pet name |
| `artifact_paths` | Key → file path |
| `labels` | Module labels |

## Used by

- [`fixtures/01-multi-instance`](../../fixtures/01-multi-instance)
