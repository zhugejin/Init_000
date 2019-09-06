HERE=pwd
OPENFRAMEWORKS_ROOT_DIR=~/code/openFrameworks

# Install ffmpeg
sudo apt install ffmpeg

# Get OBS screen recording software
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update
sudo apt-get install obs-studio

# Download OF and compile from source
git clone --recursive git@github.com:openframeworks/openFrameworks.git $OPENFRAMEWORKS_ROOT_DIR

# Build stuff
cd $OPENFRAMEWORKS_ROOT_DIR
sudo ./scripts/linux/ubuntu/install_dependencies.sh
sudo ./scripts/linux/ubuntu/install_codecs.sh

# Submodules - specifically for ./apps/projectGenerator
git submodule init
git submodule update

cd $HERE
