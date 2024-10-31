resource "aws_instance" "nginxserver" {

    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id

    user_data = <<-EOF
        #!/bin/bash
        sudo apt install nginx -y
        sudo systemctl start nginx
    EOF

    tags = {
      "Name" = "Terracreated_server"
    }

}