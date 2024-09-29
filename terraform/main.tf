provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "test-sg" {
  name        = "test-sg"
  description = "Allow SSH, HTTP, Jenkins, and SonarQube traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_instance" {
  ami           = "ami-0ed895c6c072f30d9"
  instance_type = "t2.micro"
  key_name      = "MyNewKeyPair"
  vpc_security_group_ids = [aws_security_group.test-sg.id]

  tags = {
    Name = "test-instance34"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/easwar/MyNewKeyPair.pem")
      host        = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, --private-key /home/easwar/MyNewKeyPair.pem -u ubuntu --ssh-extra-args='-o StrictHostKeyChecking=no' /home/easwar/ansible/playbooks/instance-playbook.yml"
  }


  provisioner "local-exec" {
    command = "ansible-playbook /home/easwar/ansible/jenkins-setup/auto_token.yml"
  }


  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, --private-key /home/easwar/MyNewKeyPair.pem -u ubuntu --ssh-extra-args='-o StrictHostKeyChecking=no' /home/easwar/ansible/jenkins-setup/test1.yml"
  }
}

output "instance_public_ip" {
  value = aws_instance.docker_instance.public_ip
}
