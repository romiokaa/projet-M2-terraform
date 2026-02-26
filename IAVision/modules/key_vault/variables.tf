variable "resource_group_name" { 
    type = string 
    }

variable "location" { 
    type = string 
    }

variable "tenant_id" { 
    type = string 
    }

variable "project" { 
    type = string 
    }
variable "env" { 
    type = string 
    }
    
variable "tags" { 
    type = map(string) 
    }