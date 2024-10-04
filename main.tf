provider "aws" {
region     = "ap-south-1"


}
resource "aws_instance" "name" {
  ami                    = "ami-0dee22c13ea7a9a67"
  instance_type          = "t3.micro"
  key_name               = "lms"
  vpc_security_group_ids = ["sg-0df66875e93d88998"]
  tags = {
    name = "lms"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt install python3-pip -y",
      "sudo apt install python3-venv -y",
      "python3 -m venv /home/ubuntu/venv",
      ". /home/ubuntu/venv/bin/activate",
      "git clone https://github.com/gsreddy1870/nlm2.git",
      "cd nlm2",
      "pip install django",
      "sudo apt-get install libmysqlclient-dev -y",
      "sudo apt install pkg-config -y",
      "pip install mysqlclient",
      "pip  install -r requirements.txt",
      "python /home/ubuntu/nlm2/manage.py makemigrations",
      "python /home/ubuntu/nlm2/manage.py migrate",
      "python /home/ubuntu/nlm2/manage.py runserver 0.0.0.0:8000"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("lms.pem")
      host        = self.public_ip
    }

  }

}
