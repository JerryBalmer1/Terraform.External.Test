locals {
  content_labels = merge(
    {
      module = "basic_content"
      kind   = "content"
    },
    var.labels
  )

  rendered_content = <<-EOT
    # ${var.name_prefix}
    identity_id=${var.identity_id}
    identity_name=${var.identity_name}

    ${var.content_body}
  EOT

  metadata = {
    name_prefix   = var.name_prefix
    identity_id   = var.identity_id
    identity_name = var.identity_name
    labels        = local.content_labels
    body_length   = length(var.content_body)
  }
}
