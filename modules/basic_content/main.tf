resource "local_file" "content" {
  filename        = var.content_filename
  content         = local.rendered_content
  file_permission = var.file_permission
}

resource "local_file" "metadata" {
  filename = var.metadata_filename
  content = jsonencode(merge(local.metadata, {
    content_path = local_file.content.filename
    content_sha1 = local_file.content.content_sha1
  }))
  file_permission = var.file_permission
}
