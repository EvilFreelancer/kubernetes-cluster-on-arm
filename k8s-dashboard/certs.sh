#!/bin/bash

set -xe

openssl genrsa -out ./certs/dashboard.key 2048
openssl req -days 3650 -new -key ./certs/dashboard.key -out ./certs/dashboard.csr -subj "/C=US/ST=Ohio/L=Columbus/O=Home/OU=King/CN=*.k8s.home"
openssl x509 -req -in ./certs/dashboard.csr -signkey ./certs/dashboard.key -out ./certs/dashboard.crt
openssl x509 -in ./certs/dashboard.crt -text -noout
