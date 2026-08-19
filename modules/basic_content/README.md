# basic_content

Reusable child module that writes a primary content file and a metadata JSON file via `local_file`.

## Purpose

Fixture building block for sibling module data flow: identity outputs feed content inputs, and content outputs feed root resources.

## Resources

| Address | Role |
|---------|------|
| `local_file.content` | Primary text artifact |
| `local_file.metadata` | Metadata JSON artifact |

## Inputs

| Name | Type | Required | Default |
|------|------|----------|---------|
| `name_prefix` | `string` | yes | — |
| `identity_id` | `string` | yes | — |
| `identity_name` | `string` | yes | — |
| `content_body` | `string` | yes | — |
| `content_filename` | `string` | yes | — |
| `metadata_filename` | `string` | yes | — |
| `file_permission` | `string` | no | `0644` |
| `labels` | `map(string)` | no | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `content_path` | Path to content file |
| `content_sha1` | SHA1 of content |
| `metadata_path` | Path to metadata file |
| `metadata_sha1` | SHA1 of metadata |
| `labels` | Module labels |

## Used by

- [`fixtures/01-multi-instance`](../../fixtures/01-multi-instance)
