variable "env" {
  description = "The environment we are deploying to."
  type        = string
}

variable "container_port" {
  description = "The container port."
  type        = number
}