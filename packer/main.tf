provider "aws" {
  region = "us-east-1"
}

resource "null_resource" "packer_build" {
  # Run the Packer build to create the AMI
  provisioner "local-exec" {
    command = "packer build template.pkr.hcl"
  }

  triggers = {
    build_trigger = "${timestamp()}"
  }
}

# Output block to notify completion of the Packer build
output "packer_build_status" {
  value       = "Packer build complete"
  description = "Packer has successfully created an AMI."
}