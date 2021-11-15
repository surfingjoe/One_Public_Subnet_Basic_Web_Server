# --------- Declare the AWS Region -------------------------------
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "surfingjoes-terraform-states"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}

# ------- Get Linux Ubuntu AMI ID, using SSM Parameter ----------
data "aws_ssm_parameter" "ubuntu-focal" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# ----------  Creating Web server ---------------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.ubuntu-focal.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-1.id
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  user_data = file("bootstrap.sh")
  tags = {
    Name  = "Basic-Web-Server"
    Stage = "Test"
  }
}

# ----------- Output the public ID of the Web Server ----------------
output "web" {
  value = [aws_instance.web.public_ip]
}

