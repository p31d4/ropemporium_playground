#!/bin/bash

mkdir -p ${1}
curl https://ropemporium.com/binary/${1}.zip --output ${1}/${1}.zip
cd ${1}
unzip ${1}.zip
rm ${1}.zip
