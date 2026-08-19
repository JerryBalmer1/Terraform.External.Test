output "content_path" {
  description = "Path to the primary content file."
  value       = local_file.content.filename
}

output "content_sha1" {
  description = "SHA1 hash of the primary content file."
  value       = local_file.content.content_sha1
}

output "metadata_path" {
  description = "Path to the metadata JSON file."
  value       = local_file.metadata.filename
}

output "metadata_sha1" {
  description = "SHA1 hash of the metadata JSON file."
  value       = local_file.metadata.content_sha1
}

output "labels" {
  description = "Labels associated with this content module instance."
  value       = local.content_labels
}
