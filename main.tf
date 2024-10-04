provider "aws" {
access_key = "AKIAWCYYAFTOXQR5GJAQ"
secret_key = "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"
region     = "ap-south-1"
}
resource "aws_instance" "name" {
  ami                    = "ami-0dee22c13ea7a9a67"
  instance_type          = "t3.micro"
  key_name               = "lms"
  vpc_security_group_ids = ["sg-0c4859c8c0e61b2d1"]
  tags = {
    name = "lms"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt install python3-pip -y",
      "sudo apt install python3-venv -y",
      "sudo apt install python3-virtualenv -y",
      "python3 -m venv /home/ubuntu/venv",
      ". /home/ubuntu/venv/bin/activate",
      "git clone https://github.com/deva0510/Django-WebApp.git",
      "cd Django-WebApp",
      "pip install django",
      "pip install django-crispy-forms",
      "pip install easy-pil",
      "python /home/ubuntu/Django-WebApp/manage.py makemgrations",
      "python /home/ubuntu/Django-WebApp/manage.py migrate",
      "python /home/ubuntu/Django-WebApp/manage.py runserver 0.0.0.0:8000"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("lms.pem")
      host        = self.public_ip
    }

  }

}
