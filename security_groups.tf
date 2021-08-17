
resource "aws_security_group" "web" {
  vpc_id      = aws_vpc.my-vpc.id
  description = "Allows HTTP"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name  = "SecurityGroup-Web"
    Stage = "Test"
  }
}