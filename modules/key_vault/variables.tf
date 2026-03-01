variable "resource_group_name" { 
    type = string 
    }

variable "location" { 
    type = string 
    default = "Switzerland North"
    }

variable "tenant_id" { 
    type = string 
    }

variable "project" { 
    type = string 
    default = "myprojectv2"
}

   
variable "tags" { 
    type = map(string) 
    }

variable "suffix" {
    type = string
    default = "iQdHuj"
}