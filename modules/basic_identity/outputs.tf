output "identity_id" {
  description = "Hex-encoded random identity, including prefix."
  value       = random_id.this.hex
}

output "identity_b64" {
  description = "Base64-encoded random identity payload."
  value       = random_id.this.b64_std
}

output "pet_name" {
  description = "Generated pet name with prefix."
  value       = random_pet.this.id
}

output "suffix" {
  description = "Random alphanumeric suffix."
  value       = random_string.suffix.result
}

output "composed_name" {
  description = "Combined identity name built from prefix, pet, and suffix."
  value       = local.composed_name
}

output "labels" {
  description = "Labels associated with this identity module instance."
  value       = local.identity_labels
}
