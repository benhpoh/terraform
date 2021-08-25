#!/usr/bin/env bash

cd src
curl -X GET "${TFSEC_DOWNLOAD_URL}" --output tfsec
chmod u+x tfsec
#./tfsec .
uname -a
sudo apt install golang
go version
go get 
go get -u github.com/tfsec/tfsec/cmd/tfsec
pwd
chmod u+x tfsec
./tfsec
echo $GOPATH
ls /home/vsts/work/1/s/src/tfsec