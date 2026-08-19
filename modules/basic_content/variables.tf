variable "name_prefix" {
  description = "Prefix used inside generated file contents."
  type        = string
}

variable "identity_id" {
  description = "Identity id supplied by the caller, usually from basic_identity."
  type        = string
}

variable "identity_name" {
  description = "Human-readable identity name supplied by the caller."
  type        = string
}

variable "content_body" {
  description = "Primary text body written to the content file."
  type        = string
}

variable "content_filename" {
  description = "Absolute or relative path for the primary content file."
  type        = string
}

variable "metadata_filename" {
  description = "Absolute or relative path for the metadata JSON file."
  type        = string
}

variable "file_permission" {
  description = "Unix file permission applied to created files."
  type        = string
  default     = "0644"
}

variable "labels" {
  description = "Free-form labels embedded in metadata output."
  type        = map(string)
  default     = {}
}
