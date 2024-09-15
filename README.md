# Iterative Terraform Fhonebook App

This repo contains a basic root module as well as several child modules. It is a WIP as I am taking what we did as a project in my Clarusway DevOps course and am refactoring it. Eventually the child modules will be their own repo and I am just using them here in the root for ease of learning.

The structure of the architecture is pretty straight forward. The app is written in Python with a Flask front end, supported by a MySQL database. The app is deployed across the latest version of two Amazon 2023 Linux ec2 instances sitting in a public subnet and fronted by an ALB that accepts port 80 traffic (will refactor to 443 with port 80 forwarding).

The ec2's launch template utilizes a bash script that pulls from the app from a public GitHub repo and launches it.  The launch template is then added to a target group and associated with an ASG.

The MySQL RDS database specifications align with the free tier allowances and only accepts port 3306 traffic initiated from a resource with the ec2 instance's security group.

The application reaches the database through the creation of a repository file via terraform and that contains the endpoint address which is pulled from the RDS resource block (using the address property vs endpoint to avoid the issues with the 3306 protocol being appended in the latter's data).

Finally, an A record is created in a public hosted zone in Route 53 that supports 443 and 80 traffic and which is pointed at the ALB's alias.

NOTE:
Improvements will include the creation of a custom VPC through a module I will write, updating the Security Group code to reflect best practices (separating the group and the egress and ingress rule). The SG may also get converted into a module (superfluous but I am doing for practice)
