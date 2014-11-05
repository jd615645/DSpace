#!/bin/bash

chmod 775 -Rvf $PWD
chmod 4750 -v "${BASH_SOURCE[0]}"
chmod 4750 -v "$PWD/installUpdate.sh"

# we need root permission to fix permission
# So use root to give special permission to normal user
# chmod 4750 fix_permission.sh 
