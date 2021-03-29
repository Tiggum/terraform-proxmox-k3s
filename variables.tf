variable "pm_api_url" {
  default = "https://pve1.fritz.box:8006/api2/json"
}

variable "pm_user" {
  default = "terraform-prov@pve"
}

variable "pm_password" {
  default = "terra"
}

variable "ssh_key" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}



