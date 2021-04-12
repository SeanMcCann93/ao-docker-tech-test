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

This Containerization enables a user to deploy a Docker Swarm Stack.

This is achived by building a small network that consists of a manager(master) and worker(slave) node. It works by building andprevisioning the manager node and with this new system, configuring and building its workers.

This is greate as although the containers can now be built, they also have the added benerfit of redundency.

It was also nessasery to implement Nginx into the project. This has been achived using port `3200`. I used this port as port 80 was already exposed by the main continer and did not wish to undo work already produced.

##### Improvments

Ways this system could benefit from additional features would be to convert the process into ansible scripts and utilise the opportunity for a private subnet.

This will enable more deliberate interactions with systems and prove opportunities to configure tests that run to check changes made to the system. This would be great for alleging breaches and data attempted to be reached.

A Private cloud has been implemented in this network and a system could be set up to direct data through this to improve data security and include AWS tables.

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

**This File will run the following commands:**

> * ***Enter* AMI Access Key**
> * ***Enter* AMI Secret Access Key**
> * Gather 'apt' Updates
> * Build ssh key
> * Install Terraform
> * Build Terraform (Master) ~ *BUILDS*
>> * Gather 'apt' Updates
>> * Makes New Key
>> * Installs AWS
>> * Installs Terraform
>> * Installs Docker
>> * Installs Docker-Compose
>> * Initalise Docker Swarm
>> * Build Terraform (Worker) ~ *BUILDS*
>>> * Gather 'apt' Updates
>>> * Installs Docker
>>> * Assigns server to Docker Swarm 'manager'
>> * Builds Images with Docker-Compose
>> * Deploys the Docker Swarm stack called 'AO_Stack'

##### Manager Node

Once Terraform has finished building, enter the 'manager' server to input your AWS credentials. This is so the manager server can build systems in Terraform.
By using the following you will gain access to the 'manager' server and from there will enter your AWS credentials.

> * `ssh -i "~/.ssh/AccessKey" ubuntu@ec2-${Manager-IP}.eu-west-1.compute.amazonaws.com`
>> * `aws configure`
>>> * Enter AMI Access Key
>>> * Enter AMI Secret Access Key
>>> * Enter AMI Region (eu-west-1)
>>> * Enter AMI Formate (text)

*Please note: If `aws configure` dont work. It may not yet have been installed.*

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