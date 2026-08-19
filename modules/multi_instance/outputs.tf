output "instance_count" {
  description = "Number of X instances created by this module."
  value       = local.instance_count
}

output "instance_keys" {
  description = "Keys of all created X instances."
  value       = sort(keys(local.instance_configs))
}

output "instances" {
  description = "Map of each X instance key to its resolved identity and artifact details."
  value = {
    for key, cfg in local.instance_configs : key => {
      key         = key
      label       = cfg.label
      identity_id = random_id.x[key].hex
      pet_name    = random_pet.x[key].id
      composed    = "${random_pet.x[key].id}-${random_id.x[key].hex}"
      path        = local_file.x[key].filename
      sha1        = local_file.x[key].content_sha1
    }
  }
}

output "identity_ids" {
  description = "Map of instance key to hex identity id."
  value       = { for key, res in random_id.x : key => res.hex }
}

output "pet_names" {
  description = "Map of instance key to generated pet name."
  value       = { for key, res in random_pet.x : key => res.id }
}

output "artifact_paths" {
  description = "Map of instance key to local artifact path."
  value       = { for key, res in local_file.x : key => res.filename }
}

output "labels" {
  description = "Labels associated with this multi-instance module."
  value       = local.module_labels
}
