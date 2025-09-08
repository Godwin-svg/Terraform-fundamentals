# variable for vpc cidr range
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"

}

# Project Name
variable "project_name" {
    type = string
    default = "Apache"
  
}