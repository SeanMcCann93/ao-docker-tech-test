#!/bin/bash

# temp_access="" # Test Purose Only ~ Never Upload this
# temp_sec_access="" # Test Purose Only ~ Never Upload this
temp_location="eu-west-1" # Enter Region
locking="false" # This if 'true' will lock the system from accidental termination

echo "AWS Configure"
if [ -z ${temp_access} ]
then
    read -p 'AWS Access Key : ' temp
    temp_access="${temp}"
    break
else
    echo "AWS Access Key ~Pass"
    break
fi

if [ -z ${temp_sec_access} ]
then
    stty -echo
    read -p "AWS Secret Access Key: " temp
    temp_sec_access="${temp}"
    stty echo
    echo ""
else
    echo "AWS Secret Access Key ~Pass"
    break
fi

if [ -z ${temp_location} ]
then
    read -p 'AWS Region? ' temp
    temp_location="${temp}"
    echo ""
else
    echo "AWS Region ~Pass"
    break
fi

echo ""

sudo apt-get update -y

chmod +x ./install/*
echo ""

TEMP=~/.ssh/AccessKey
if [ -f "${TEMP}" ]
then
    echo "Key Exists!"
    echo ""
    break
else
    sh ./install/keygen.sh
    break
fi

TEMP=/usr/local/bin/terraform
if [ -f "${TEMP}" ]
then
    terraform --version
    echo ""
    break
else
    sh ./install/terra.sh
    break
fi

sudo apt install awscli -y

aws configure set default.region ${temp_location}
aws configure set aws_access_key_id ${temp_access}
aws configure set aws_secret_access_key ${temp_sec_access}
aws configure set default.output "text"

echo ""

cd Terraform/builds/instance && terraform init

echo ""
echo "        :::::::::  :::    ::: ::::::::: :::       :::::::::"
echo "       :+:    :+: :+:    :+:    :+:    :+:       :+:    :+:"
echo "      +:+    +:+ +:+    +:+    +:+    +:+       +:+    +:+"
echo "     +#++:++#+  +#+    +:+    +#+    +#+       +#+    +:+"
echo "    +#+    +#+ +#+    +#+    +#+    +#+       +#+    +#+"
echo "   #+#    #+# #+#    #+#    #+#    #+#       #+#    #+#"
echo "  #########   ########  ######### ######### #########"
echo ""

terraform apply -var locked="${locking}" -var aws_location="${temp_location}" -auto-approve

echo ""

sudo apt autoremove

echo ""
echo "Thank you for launching this application."
echo "It can take around 5 min to launch the application on the above link."
echo ""
