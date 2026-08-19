variable "name_prefix" {
  description = "Prefix included in generated multi-instance values."
  type        = string
}

variable "instances" {
  description = "Map of instance keys to per-instance configuration. Each entry creates one instance of X."
  type = map(object({
    label       = optional(string)
    pet_length  = optional(number, 2)
    byte_length = optional(number, 4)
  }))
  default = {
    "a" = { label = "alpha" }
    "b" = { label = "bravo" }
  }
}

variable "output_directory" {
  description = "Directory where per-instance artifact files are written."
  type        = string
}

variable "file_permission" {
  description = "Unix file permission applied to created files."
  type        = string
  default     = "0644"
}

variable "labels" {
  description = "Free-form labels stored in module locals and outputs."
  type        = map(string)
  default     = {}
}
