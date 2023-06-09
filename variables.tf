#

variable "region" {
  description = "AWS region"
}

variable "environment_name" {
  description = "Environment name"
}

variable "ssh_key" {
  description = "Admin SSH key"
}

variable "cidr_block" {
  description = "VPC CIDR"
}

variable "subnet_block" {
  description = "Subnet CIDR"
}

variable "environment_spec" {
  description = "Map of nodes"
  default     = {
    node-01 = {
      node_number     = 1,
      instance_type   = "t2.micro",
      root_volume_iops = "3000",
      root_volume_size = "50",
      root_volume_type = "gp3",
      data_volume_iops = "3000",
      data_volume_size = "100",
      data_volume_type = "gp3"
    }
    node-02 = {
      node_number     = 2,
      instance_type   = "t2.micro",
      root_volume_iops = "3000",
      root_volume_size = "50",
      root_volume_type = "gp3",
      data_volume_iops = "3000",
      data_volume_size = "100",
      data_volume_type = "gp3"
    }
    node-03 = {
      node_number     = 3,
      instance_type   = "t2.micro",
      root_volume_iops = "3000",
      root_volume_size = "50",
      root_volume_type = "gp3",
      data_volume_iops = "3000",
      data_volume_size = "100",
      data_volume_type = "gp3"
    }
  }
}
