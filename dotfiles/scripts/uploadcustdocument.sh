#!/bin/bash

cd $CUSTOMERS_PATH
pwd
git add .
git commit -m "Update"
rclone -v copy ~/git/work/customers gdrive:Customers --exclude=/.git/ --exclude=/.obsidian/ --exclude=/.html/
