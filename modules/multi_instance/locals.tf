locals {
  normalized_prefix = lower(replace(var.name_prefix, "/[^a-zA-Z0-9]+/", "-"))

  module_labels = merge(
    {
      module = "multi_instance"
      kind   = "multi"
    },
    var.labels
  )

  # One resolved config object per requested instance of X.
  instance_configs = {
    for key, cfg in var.instances : key => {
      key         = key
      label       = coalesce(try(cfg.label, null), key)
      pet_length  = coalesce(try(cfg.pet_length, null), 2)
      byte_length = coalesce(try(cfg.byte_length, null), 4)
      filename    = "${var.output_directory}/${local.normalized_prefix}.${key}.instance.json"
    }
  }

  instance_count = length(local.instance_configs)
}
