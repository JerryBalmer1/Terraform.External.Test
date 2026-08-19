# basic_identity

Reusable child module that creates a single synthetic identity from `random_id`, `random_pet`, and `random_string`.

## Purpose

Fixture building block for single-instance nested module graphs and sibling data flow into content modules.

## Resources

| Address | Role |
|---------|------|
| `random_id.this` | Hex identity with prefix |
| `random_pet.this` | Pet name with prefix |
| `random_string.suffix` | Alphanumeric suffix |

## Inputs

| Name | Type | Required | Default |
|------|------|----------|---------|
| `name_prefix` | `string` | yes | — |
| `byte_length` | `number` | no | `4` |
| `pet_length` | `number` | no | `2` |
| `string_length` | `number` | no | `6` |
| `labels` | `map(string)` | no | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `identity_id` | Hex identity |
| `identity_b64` | Base64 identity |
| `pet_name` | Pet name |
| `suffix` | Random suffix |
| `composed_name` | Prefix + pet + suffix |
| `labels` | Module labels |

## Used by

- [`fixtures/01-multi-instance`](../../fixtures/01-multi-instance)
