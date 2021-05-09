[windows-store]: https://www.microsoft.com/store/productId/9NBLGGH4MSV6
[ubuntu-plug]: https://marketplace.visualstudio.com/items?itemName=Docter60.vscode-terminal-for-ubuntu
[aws-IAM]: https://console.aws.amazon.com/iam/home
[Overview-img]: https://github.com/SeanSnake93/ao-docker-tech-test/blob/dockerComp/docs/overview.png

# AO Tech Challenge

Welcome to the AO Tech challenge!

This challenge consists of three exercises - Each is representative of a problem we have run across at AO. The first two exercises are technical and the third exercise is theoretical.
Solutions to each exercise will be evaluated on the following criteria:

- Completeness
- Correctness
- Legibility
- Aesthetics

## Overview

![Network Overview][Overview-img]

This dockerComp enables a user to deploy a Docker Compose Stack on a local machine.

This is achived by building a single instance within a cloud network. It works by building a PC and previsioning an instance within a public subnet. The system when launched is configured using install scripts that are run upon downloading the application and changing to this branch.

It was required that Nginx was implemented so that the application could take advantage of the capabilities of the software (loadbalancing, proxy etc;). As to implement it without undoing work already presented I utilised port `3200`. This port has been oped in the security group and will port forward from this location to the standard http port `80`.

##### Improvments

With this server only existing on a single instance we have the opportunity to expand the resiliency of the application in many forms. We can utilise a Docker Hub account to expand the network without the need for git pull requests, using ansible to install software on remote servers for us for clear confirmation and deliberate changes.

It will enable opportunities to perform closed operations on the application without affecting a front end/the main deployment. This allowed for the application to be restructured to benefit from the opportunities Terraform and other application combined can present in an AWS cloud platform. Quick to deploy, reliable hardware produced through additions made to the terraform file. With this model, A private cloud has been established.

One reason for this is because Table instances require a VPC hosting 2 or more subnets, but it can host instances that are required both legally and morally with great care. This means encryption and storing away in locations that only those with access can see. It is this reason a private cloud can be useful. It may even be ideal to use instances that host keys to tools, operations, infrastructure through a key management system. Enabling users given specific credentials to access specific tagged locations only or rights to affect the inner workings of your entire application.

## Pre-requisites

* Ubuntu Bash Terminal
* AWS IAM User

### Install Ubuntu [Windows]

Ubuntu can be installed via the [windows store][windows-store].

> When first creating your account you will be asked to set up a new User.
> (NOTE: This is separate from your standard Windows User.)

> If using Visual Studio Code, a [Ubuntu plugin][ubuntu-plug] can be enabled to use this terminal here. Using `Ctrl + atl + U` should display the terminal once enabled.

### IAM Roles

To run this build, you will require a [IAM User][aws-IAM].

To produce this you will need to have access to the following Policy attached.

>`{`

>>`    "Version": "2012-10-17",`
>>`    "Statement": [`

>>>`        {`

>>>>`            "Effect": "Allow",`
>>>>`            "Action": [`

>>>>>`                "ec2:AuthorizeSecurityGroupIngress",`
>>>>>`                "ec2:DeleteSubnet",`
>>>>>`                "ec2:DescribeInstances",`
>>>>>`                "ec2:DeleteTags",`
>>>>>`                "ec2:DescribeInstanceAttribute",`
>>>>>`                "ec2:CreateVpc",`
>>>>>`                "ec2:AttachInternetGateway",`
>>>>>`                "ec2:DescribeVpcAttribute",`
>>>>>`                "ec2:DeleteRouteTable",`
>>>>>`                "ec2:ModifySubnetAttribute",`
>>>>>`                "ec2:AssociateRouteTable",`
>>>>>`                "ec2:DescribeInternetGateways",`
>>>>>`                "ec2:DescribeNetworkInterfaces",`
>>>>>`                "ec2:DescribeAvailabilityZones",`
>>>>>`                "ec2:CreateRoute",`
>>>>>`                "ec2:CreateInternetGateway",`
>>>>>`                "ec2:RevokeSecurityGroupEgress",`
>>>>>`                "ec2:CreateSecurityGroup",`
>>>>>`                "ec2:DescribeVolumes",`
>>>>>`                "ec2:DescribeAccountAttributes",`
>>>>>`                "ec2:ModifyVpcAttribute",`
>>>>>`                "ec2:DeleteInternetGateway",`
>>>>>`                "ec2:ModifyInstanceAttribute",`
>>>>>`                "ec2:DescribeKeyPairs",`
>>>>>`                "ec2:DescribeNetworkAcls",`
>>>>>`                "ec2:DescribeRouteTables",`
>>>>>`                "ec2:AuthorizeSecurityGroupEgress",`
>>>>>`                "ec2:TerminateInstances",`
>>>>>`                "ec2:DescribeVpcClassicLinkDnsSupport",`
>>>>>`                "ec2:CreateTags",`
>>>>>`                "ec2:CreateRouteTable",`
>>>>>`                "ec2:RunInstances",`
>>>>>`                "ec2:DetachInternetGateway",`
>>>>>`                "ec2:DisassociateRouteTable",`
>>>>>`                "ec2:DescribeInstanceCreditSpecifications",`
>>>>>`                "ec2:DescribeSecurityGroups",`
>>>>>`                "ec2:DescribeVpcClassicLink",`
>>>>>`                "ec2:DescribeVpcs",`
>>>>>`                "ec2:DeleteSecurityGroup",`
>>>>>`                "ec2:DeleteVpc",`
>>>>>`                "ec2:CreateSubnet",`
>>>>>`                "ec2:DescribeSubnets",`
>>>>>`                "ec2:DeleteKeyPair"`

>>>>`            ],`
>>>>`            "Resource": "*"`

>>>`        },`
>>>`        {`

>>>>`            "Effect": "Allow",`
>>>>`            "Action": "ec2:ImportKeyPair",`
>>>>`            "Resource": "arn:aws:ec2:*:*:key-pair/*"`

>>>`        }`

>>`    ]`

>`}`

### Instructions Deploy & Destroy

##### Local System

- `git clone https://github.com/SeanSnake93/ao-docker-tech-test`
- `cd ao-docker-tech-test`
- `git checkout dockerComp`

#### Deploy

- `sh A.sh`

**This File will run the following commands:**

> * **AMI Access Key** `Enter Here`
> * **AMI Secret Access Key** `Enter Here`
> * Gather 'apt' Updates
> * Build ssh key
> * Install Terraform
> * Build Terraform (instance) ~ *BUILDS*
>> * Gather 'apt' Updates
>> * Installs Docker
>> * Installs Docker-Compose
>> * Builds Images with Docker-Compose and launches application

### Destroy

- `sh destroy.sh`
>> * destroy Manager Node and Network
>> *May require you to re-`aws configure` your aws over long periods*