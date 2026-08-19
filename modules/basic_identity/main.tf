resource "random_id" "this" {
  byte_length = var.byte_length
  prefix      = "${local.normalized_prefix}-"

  keepers = {
    name_prefix = local.normalized_prefix
    byte_length = tostring(var.byte_length)
  }
}

resource "random_pet" "this" {
  length    = var.pet_length
  separator = "-"
  prefix    = local.normalized_prefix

  keepers = {
    name_prefix = local.normalized_prefix
    pet_length  = tostring(var.pet_length)
  }
}

resource "random_string" "suffix" {
  length  = var.string_length
  upper   = false
  lower   = true
  numeric = true
  special = false

  keepers = {
    name_prefix   = local.normalized_prefix
    string_length = tostring(var.string_length)
  }
}
