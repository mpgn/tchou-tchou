#!/bin/bash

rm /home/demoniac/myapp/config/credentials.yml.enc 
rm /home/demoniac/myapp/config/master.key 
cd /home/demoniac/myapp && EDITOR='vi -N -u NONE -n -c "wq"' rails credentials:edit
cd /home/demoniac/myapp && rails restart
date >> /tmp/restart.txt
