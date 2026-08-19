locals {
  normalized_prefix = lower(replace(var.name_prefix, "/[^a-zA-Z0-9]+/", "-"))

  identity_labels = merge(
    {
      module = "basic_identity"
      kind   = "identity"
    },
    var.labels
  )

  composed_name = join("-", compact([
    local.normalized_prefix,
    random_pet.this.id,
    random_string.suffix.result
  ]))
}
