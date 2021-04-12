#!/bin/bash
locking="false"
temp_location="eu-west-1"
Token=""
IPLink=""
cd Terraform/builds/worker/
echo ""
echo "        :::::::::  ::::::::: :::::::::: :::::::::: :::::::::   ::::::::  :::   :::  "
echo "       :+:    :+: :+:       :+:    :+:    :+:     :+:    :+: :+:    :+: :+:   :+:   "
echo "      +:+    +:+ +:+       +:+           +:+     +:+    +:+ +:+    +:+  +:+ +:+     "
echo "     +#+    +:+ +#++:++#  +#++:++#++    +#+     +#++:++#:  +#+    +:+   +#++:       "
echo "    +#+    +#+ +#+              +#+    +#+     +#+    +#+ +#+    +#+    +#+         "
echo "   #+#    #+# #+#       #+#    #+#    #+#     #+#    #+# #+#    #+#    #+#          "
echo "  #########  ######### #########     ###     ###    ###  ########     ###           "
echo ""
terraform destroy -var locked="${locking}" -var IPLink="${IPLink}" -var Token="${Token}" -var aws_location="${temp_location}" -auto-approve
echo ""
cd ./../manager/
terraform destroy -var locked="${locking}" -var aws_location="${temp_location}" -auto-approve
# terraform destroy -var locked="false" -var aws_location="eu-west-1" -auto-approve