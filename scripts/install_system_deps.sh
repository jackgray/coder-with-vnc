#!/bin/bash

set -e

# Install system dependencies
apt-get update  -y
apt-get install -y --ignore-missing \
  ca-certificates \
  curl \
  gnupg \
  software-properties-common \
  xvfb \
  libgtk-3-0 \
  libnotify4 \
  libsdl1.2debian \
  libosmesa6 \
  bzip2 \
  wget \
  rsync \
  git \
  bc \
  jq \
  nano \
  vim \
  libopenblas-dev \
  gfortran \
  libhdf5-dev \
  openssh-client \
  python3-wxgtk4.0 

# install Node.js
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
apt update
apt install -y nodejs

# apt install -y locales
# locale-gen en_US.UTF-8
# # locale-gen en_GB.UTF-8
# update-locale

cat /etc/lsb-release | grep "14.04" && apt-get install -y libspatialindex-c3   || true
cat /etc/lsb-release | grep "16.04" && apt-get install -y libspatialindex-c4v5 || true
cat /etc/lsb-release | grep "18.04" && apt-get install -y libspatialindex-c4v5 || true
cat /etc/lsb-release | grep "20.04" && apt-get install -y libspatialindex-c6   || true

# "pip install rtree" doesn't seem to
# lookup libspatialindex correctly
pushd /usr/lib/x86_64-linux-gnu/ > /dev/null

lsi=`ldconfig -p | grep libspatialindex.so | tr -d '\t' | cut -d ' ' -f 1`
lsi_c=`ldconfig -p | grep libspatialindex_c.so | tr -d '\t' | cut -d ' ' -f 1`

ln -s "$lsi"   libspatialindex.so
ln -s "$lsi_c" libspatialindex_c.so

popd > /dev/null
