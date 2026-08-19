variable "name_prefix" {
  description = "Prefix included in generated identity values."
  type        = string
}

variable "byte_length" {
  description = "Number of random bytes for random_id."
  type        = number
  default     = 4
}

variable "pet_length" {
  description = "Number of words in the generated pet name."
  type        = number
  default     = 2
}

variable "string_length" {
  description = "Length of the random suffix string."
  type        = number
  default     = 6
}

variable "labels" {
  description = "Free-form labels stored in module locals and outputs."
  type        = map(string)
  default     = {}
}
