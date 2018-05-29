#!/bin/bash -x


apt-get update && apt-get install -y mc

wget 'https://bintray.com/jfrog/jfrog-cli-go/download_file?file_path=${jfrog_cli_version}%2Fjfrog-cli-linux-amd64%2Fjfrog' -O /usr/local/bin/jfrog
chmod +x /usr/local/bin/jfrog

/usr/local/bin/jfrog -v

cat << 'EOF' > /tmp/download_terraform.sh
$${data.template_file.download_terraform_script.rendered}
EOF
