#!/bin/bash -x 


TF_VERSION="${tf_version}"
cd /tmp && wget https://releases.hashicorp.com/terraform/$${TF_VERSION}/terraform_$${TF_VERSION}_linux_amd64.zip

unzip terraform_$${TF_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/

/usr/local/bin/terraform -v
