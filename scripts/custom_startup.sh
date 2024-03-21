#! /bin/bash

export KASM_USER=$1


# echo "Changing name of kasm-user to $KASM_USER"

# # Move out of home dir
# cd /home
# # confirm
# pwd

# # Rename user
# usermod -l $KASM_USER kasm-user

# # Move home directory
# echo "Moving home directory"
# usermod -d /home/${KASM_USER} -m $KASM_USER

# # Modify group
# echo "Changing name of group kasm-user to narclab"
# groupmod -n narclab kasm-user
# echo "Adding narclab as group in case above fails"
# groupadd narclab
# echo "Adding $KASM_USER to group narclab"
# usermod -aG narclab ${KASM_USER}

# echo "$KASM_USER ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

# DEBIAN_FRONTEND=noninteractive make-ssl-cert generate-default-snakeoil --force-overwrite

# HOME=/home/$KASM_USER

# # Switch to the user's environment
# echo "Moving from $(pwd) to $HOME"
# cd /home/$KASM_USER
# echo "Should now be in home/$KASM_USER (your username) -- check: "
# pwd

# echo "Copying contents of /home/kasm-user to new home $HOME"
# cp -a /home/kasm-user/. /home/$KASM_USER

# # Change ownership of home directory
# echo "Fixing permissions of home directory"
# chown $KASM_USER:narclab /home/${KASM_USER}/


# Initialize FSL
sudo bash /usr/local/fsl/etc/fslconf/fsl.sh

# echo Script set to skip custom startup

# echo "Switching to new user $KASM_USER"
# sudo su $KASM_USER
# cd $HOME


export HOME=/home/${KASM_USER}
cp -r /home/kasm-user/* $HOME
cd $HOME

sudo useradd --groups sudo --no-create-home --shell /bin/bash ${KASM_USER} 
echo "${KASM_USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${KASM_USER}
sudo chmod 0440 /etc/sudoers.d/${KASM_USER}
sudo su ${KASM_USER}
