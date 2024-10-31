variable "ec-config" {
  
  type = list(object({
    ami = string
    instance_type = string
  }))

}