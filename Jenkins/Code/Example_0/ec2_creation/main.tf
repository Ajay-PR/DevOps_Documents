provider "aws" {
    region = var.AWS_REGION
}

resource "aws_instance" "ec2_instance" {
    ami = "ami-052c08d70def0ac62"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-0a254ce4223288a2a"]
    tags = {Name = "HTTP_SERVER"}
    key_name = "terraform"

provisioner "remote-exec" {
 inline = ["sudo yum install httpd -y", "sudo chmod 777 /var/www/html", "sudo service httpd start"]
 }

provisioner "file" {
 source = "/data/devops/Jenkins-workspace/Example_0/mywebsite.html"
 destination = "/var/www/html/mywebsite.html"
 }

connection {
  host = self.public_ip
  user = "ec2-user"
  private_key = file("/data/devops/Jenkins-workspace/Example_0/terraform.pem")    
    }
}