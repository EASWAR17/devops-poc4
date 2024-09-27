packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "PACKER-DEMO"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0e86e20dae9224db8"
  ssh_username  = "ubuntu"

}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {
    playbook_file = "setup.yml"
  }
}