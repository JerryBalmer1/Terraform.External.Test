locals {
  name_prefix = join(var.name_separator, compact([
    var.project_name,
    var.environment
  ]))

  common_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "external-module-test"
  }

  content_filename  = "${path.module}/${var.output_directory}/${local.name_prefix}.txt"
  metadata_filename = "${path.module}/${var.output_directory}/${local.name_prefix}.metadata.json"
  multi_output_dir  = "${path.module}/${var.output_directory}/multi"

  bundle_trigger = {
    identity_id   = module.basic_identity.identity_id
    identity_name = module.basic_identity.pet_name
    content_sha1  = module.basic_content.content_sha1
    multi_count   = tostring(module.multi_instance.instance_count)
  }
}
