#!/usr/bin/env bash

# 2023-02-18 remove 'protect' p flag from the cp
# in copy_default_to_home to prevent a pvc home
# from wiping out the kasmvnc stuff

set -x
DEFAULT_PROFILE_HOME=/home/kasm-default-profile
PROFILE_SYNC_DIR=/kasm_profile_sync
# export HOME=/home/kasm-user

cp -r /home/kasm-user /tmp/kasm-user

# echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

# DEBIAN_FRONTEND=noninteractive make-ssl-cert generate-default-snakeoil --force-overwrite




function copy_default_profile_to_home {
    echo "Copying default profile to home directory"
    cp -r $DEFAULT_PROFILE_HOME/.  $HOME/
    ls -la $HOME
}

function verify_profile_config {
    echo "Verifying Uploads/Downloads Configurations"

    sudo mkdir -p $HOME/Uploads

    if [ -d "$HOME/Desktop/Uploads" ]; then
        echo "Uploads Desktop Symlink Exists"
    else
        echo "Creating Uploads Desktop Symlink"
        ln -sf $HOME/Uploads $HOME/Desktop/Uploads
    fi


    sudo mkdir -p $HOME/Downloads

    if [ -d "$HOME/Desktop/Downloads" ]; then
        echo "Downloads Desktop Symlink Exists"
    else
        echo "Creating Download Desktop Symlink"
        ln -sf $HOME/Downloads $HOME/Desktop/Downloads
    fi


    if [ -d "$KASM_VNC_PATH/Downloads/Downloads" ]; then
        echo "Downloads RX Symlink Exists"
    else
        echo "Creating Downloads RX Symlink"
        ln -sf $HOME/Downloads $KASM_VNC_PATH/www/Downloads/Downloads
    fi

    ls -la $HOME/Desktop

}

if  [ -f "$HOME/.bashrc" ]; then
    echo "Profile already exists. Will not copy default contents"
else
    echo "Profile Sync Directory Does Not Exist. No Sync will occur"
    copy_default_profile_to_home
fi

verify_profile_config

rm -rf $HOME/.config/pulse

echo "Removing Default Profile Directory"
rm -rf $DEFAULT_PROFILE_HOME/*


# unknown option ==> call command
echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
echo "Executing command: '$@'"
exec "$@"