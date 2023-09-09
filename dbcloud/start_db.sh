#!/bin/bash

apt-get update

service mysql start

while [ 1 -le 10 ]
do
    sleep 1
done
