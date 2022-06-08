#!/bin/sh

mkdir -p lib
cd lib

curl -LOR ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-x64-linux.tar.gz

tar -zxvf blast-2.2.26-x64-linux.tar.gz
ln -s blast-2.2.26 blast
