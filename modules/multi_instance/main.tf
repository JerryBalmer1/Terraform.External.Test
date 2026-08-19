# Creates more than one instance of X (identity + artifact) via for_each.
# Sole purpose: exercise multi-instance module patterns for external tooling tests.
# Graph shape is driven only by var.instances keys (stable); random_* values are content only.

resource "random_id" "x" {
  for_each = local.instance_configs

  byte_length = each.value.byte_length
  prefix      = "${local.normalized_prefix}-${each.key}-"

  keepers = {
    instance_key = each.key
    name_prefix  = local.normalized_prefix
    byte_length  = tostring(each.value.byte_length)
  }
}

resource "random_pet" "x" {
  for_each = local.instance_configs

  length    = each.value.pet_length
  separator = "-"
  prefix    = "${local.normalized_prefix}-${each.key}"

  keepers = {
    instance_key = each.key
    name_prefix  = local.normalized_prefix
    pet_length   = tostring(each.value.pet_length)
  }
}

resource "local_file" "x" {
  for_each = local.instance_configs

  filename        = each.value.filename
  file_permission = var.file_permission
  content = jsonencode({
    key         = each.key
    label       = each.value.label
    name_prefix = local.normalized_prefix
    identity_id = random_id.x[each.key].hex
    pet_name    = random_pet.x[each.key].id
    composed    = "${random_pet.x[each.key].id}-${random_id.x[each.key].hex}"
    labels      = merge(local.module_labels, { instance = each.key, label = each.value.label })
  })
}
