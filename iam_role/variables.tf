variable "name" {
  type = string
  description = "Name of role"
}

variable "assume_services" {
  type = list(string)
  description = "List of services this role can assume as"
  default = []
}

variable "attach_policy_arns" {
  type = list(string)
  description = "ARNs of policies to attach"
  default = []
}

variable "inline_policy_name" {
  type = string
  default = null
}

variable "inline_policies" {
  type = list(object({
    sid: optional(string)
    effect: string,
    resources: list(string),
    actions: list(string)
  }))
  default = []
}