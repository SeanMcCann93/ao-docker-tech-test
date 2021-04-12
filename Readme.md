[windows-store]: https://www.microsoft.com/store/productId/9NBLGGH4MSV6
[ubuntu-plug]: https://marketplace.visualstudio.com/items?itemName=Docter60.vscode-terminal-for-ubuntu
[aws-IAM]: https://console.aws.amazon.com/iam/home
[Overview-img]: https://github.com/SeanSnake93/ao-docker-tech-test/blob/containerize/docs/overview.png

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

> To produce this you will need to have access to the following Policies.
> * AmazonsEC2FullAccess

### Instructions

##### Local System

- `git clone https://github.com/SeanSnake93/ao-docker-tech-test`
- `cd ao-docker-tech-test`
- `git checkout containerize`
- `sh A.sh`
    - Enter AMI Access Key
    - Enter AMI Secret Access Key
>> * Gather 'apt' Updates
>> * Build ssh key
>> * Install Terraform
>> * Build Terraform (Master)
- `ssh -i "~/.ssh/AccessKey" ubuntu@ec2-${Manager-IP}.eu-west-1.compute.amazonaws.com`
> This will take you into the Manager Node.
> The IP addrss is presented to you following the build of the Manager Terraform.

##### Manager Node

- `aws configure`
    - Enter AMI Access Key
    - Enter AMI Secret Access Key
    - Enter AMI Region (eu-west-1)
    - Enter AMI Formate (text)

### Destroy

Please Note: The destroy file will fail either worker or manager depending on location. the worker is destroyed first within the network and is done so on the master node as it generates a unique key that it alone has access to.

##### Local System

- `cd ao-docker-tech-test`
- `ssh -i "~/.ssh/AccessKey" ubuntu@ec2-${Manager-IP}.eu-west-1.compute.amazonaws.com`

##### Manager Node

- `cd ao-docker-tech-test`
- `sudo su`
- `sh destroy.sh`
>> * destroy Worker Nodes
- `exit`
- `exit`

##### Local System

- `sh destroy.sh`
>> * destroy Manager Node and Network