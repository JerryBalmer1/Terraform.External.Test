module "basic_identity" {
  source = "../../modules/basic_identity"

  name_prefix = local.name_prefix
  byte_length = var.identity_byte_length
  labels      = local.common_labels
}

module "basic_content" {
  source = "../../modules/basic_content"

  name_prefix       = local.name_prefix
  identity_id       = module.basic_identity.identity_id
  identity_name     = module.basic_identity.pet_name
  content_body      = var.content_body
  content_filename  = local.content_filename
  metadata_filename = local.metadata_filename
  labels            = local.common_labels
}

# Nested module whose sole purpose is to create more than one instance of X.
module "multi_instance" {
  source = "../../modules/multi_instance"

  name_prefix      = local.name_prefix
  instances        = var.multi_instances
  output_directory = local.multi_output_dir
  labels           = local.common_labels
}

resource "null_resource" "bundle_marker" {
  count = var.enable_bundle_marker ? 1 : 0

  triggers = local.bundle_trigger

  provisioner "local-exec" {
    command = "echo Bundle ready for ${self.triggers.identity_name} (${self.triggers.identity_id})"
  }
}

resource "local_file" "root_summary" {
  filename = "${path.module}/${var.output_directory}/${local.name_prefix}.summary.json"
  content = jsonencode({
    project_name     = var.project_name
    environment      = var.environment
    name_prefix      = local.name_prefix
    identity_id      = module.basic_identity.identity_id
    identity_name    = module.basic_identity.pet_name
    content_file     = module.basic_content.content_path
    content_sha1     = module.basic_content.content_sha1
    multi_count      = module.multi_instance.instance_count
    multi_keys       = module.multi_instance.instance_keys
    multi_identities = module.multi_instance.identity_ids
    labels           = local.common_labels
    bundle_enabled   = var.enable_bundle_marker
  })
}
