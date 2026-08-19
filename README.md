# Terraform.External.Test

Terraform **fixture corpus** for torturing a downstream PowerShell diagram generator (config + state → `.drawio`). Not production infrastructure. Never deploy to a cloud account.

Design principle: if a Terraform construct can confuse a diagram generator, this repo should eventually contain a fixture that exercises it.

Operator protocol for agents: see [AGENTS.md](AGENTS.md).

## Layout

```text
/modules/<name>/                 # reusable child modules
/fixtures/<NN>-<scenario>/       # runnable root configs
/analysis/                       # static analysis artifacts
/AGENTS.md
```

| Path | Role |
|------|------|
| [modules/basic_identity](modules/basic_identity) | Single identity (`random_id` / `random_pet` / `random_string`) |
| [modules/basic_content](modules/basic_content) | Content + metadata `local_file` pair |
| [modules/multi_instance](modules/multi_instance) | **More than one instance of X** via resource `for_each` |
| [fixtures/01-multi-instance](fixtures/01-multi-instance) | Root wiring identity + content + multi_instance |
| [analysis/01-multi-instance.analysis.md](analysis/01-multi-instance.analysis.md) | Inventory, data flow, coverage, constraints, gaps |

## Providers (allowlist only)

- `hashicorp/random`
- `hashicorp/local`
- `hashicorp/null`

No credentials. No network side effects at plan/apply. No `backend` / `cloud` blocks. State stays local.

## Consuming modules from another root

Point `source` at a **git** URL plus a **subdirectory** (`//modules/...`). Do not use the GitHub web `/tree/...` URL.

Pin with `?ref=<branch|tag|sha>`. Prefer a commit SHA once you care about reproducibility.

### `basic_identity`

```hcl
module "basic_identity" {
  source = "git::https://github.com/JerryBalmer1/Terraform.External.Test.git//modules/basic_identity?ref=main"

  name_prefix = "demo"
  byte_length = 4
  pet_length  = 2
  string_length = 6
  labels = {
    env = "dev"
  }
}

output "identity_id" {
  value = module.basic_identity.identity_id
}

output "pet_name" {
  value = module.basic_identity.pet_name
}
```

### `basic_content`

Usually fed by `basic_identity` outputs (sibling wiring). Paths are caller-owned.

```hcl
module "basic_content" {
  source = "git::https://github.com/JerryBalmer1/Terraform.External.Test.git//modules/basic_content?ref=main"

  name_prefix       = "demo"
  identity_id       = module.basic_identity.identity_id
  identity_name     = module.basic_identity.pet_name
  content_body      = "hello from basic_content"
  content_filename  = "${path.module}/generated/demo.content.txt"
  metadata_filename = "${path.module}/generated/demo.metadata.json"
  labels = {
    env = "dev"
  }
}

output "content_path" {
  value = module.basic_content.content_path
}

output "content_sha1" {
  value = module.basic_content.content_sha1
}
```

### `multi_instance`

Creates one instance of X per map key via resource `for_each`.

```hcl
module "multi_instance" {
  source = "git::https://github.com/JerryBalmer1/Terraform.External.Test.git//modules/multi_instance?ref=main"

  name_prefix      = "demo"
  output_directory = "${path.module}/generated/multi"
  instances = {
    alpha = { label = "alpha", pet_length = 2, byte_length = 4 }
    bravo = { label = "bravo" }
    charlie = { label = "charlie", byte_length = 8 }
  }
  labels = {
    env = "dev"
  }
}

output "multi_keys" {
  value = module.multi_instance.instance_keys
}

output "multi_identities" {
  value = module.multi_instance.identity_ids
}
```

### Local clone (in-repo fixtures)

Inside this repository, fixtures use relative paths instead of git:

```hcl
source = "../../modules/basic_identity"
source = "../../modules/basic_content"
source = "../../modules/multi_instance"
```

### Init

From your consumer root:

```powershell
terraform init
terraform plan
```

Private clones need normal git auth (SSH key or HTTPS credential/PAT). Terraform stores the checkout under `.terraform/modules/`.

## Fixture: 01-multi-instance

Primary scenario for multi-instance coverage.

- Root variables all have defaults (zero-input `Invoke-Build Build`).
- Nested `multi_instance` expands three default keys: `alpha`, `bravo`, `charlie`.
- Sibling data flow: `basic_identity` → `basic_content`.
- Root `null_resource.bundle_marker` uses `count` + triggers from nested outputs.
- Artifacts under the fixture's `generated/` directory (cleaned by `Invoke-Build Clean`).

Details, expected nodes/edges: [fixtures/01-multi-instance/README.md](fixtures/01-multi-instance/README.md).

## How to verify a fixture

From the repository root (or as configured by the build entrypoint):

```powershell
Invoke-Build Build     # terraform init, apply -auto-approve, destroy -auto-approve
Invoke-Build Clean     # remove .terraform, state, generated artifacts
```

Do **not** use raw `terraform init` / `apply` / `destroy` for lifecycle proof. Read-only `terraform fmt` and `terraform validate` are allowed.

## Coverage status (high level)

Covered in `01-multi-instance` (non-exhaustive): var→module, var→local→module, `map(object)` + `optional()`, resource `count`, resource `for_each` over map, sibling modules, `for` map expressions, `merge`/`join`/`try`/`coalesce`/`tostring`, module and resource outputs including multi-instance maps.

Not yet covered (see analysis gaps): module `count`/`for_each`, grandchild nesting, `dynamic`, sensitive outputs, `moved`, lifecycle pre/postconditions, provider aliases, and other §4 rows listed in the analysis artifact.
