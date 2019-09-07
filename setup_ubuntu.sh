HERE=$PWD
DEFAULT_ROOT_DIR=$HOME

# Where do we put it all?
read -p "Where do you want to install openFrameworks? (default $DEFAULT_ROOT_DIR): " USER_DEFINED_ROOT_DIR

if [ -z "$USER_DEFINED_ROOT_DIR" ]; then
    OPENFRAMEWORKS_DIR=$DEFAULT_ROOT_DIR/openFrameworks
else
    OPENFRAMEWORKS_DIR=$USER_DEFINED_ROOT_DIR/openFrameworks
fi

# Install ffmpeg
sudo apt install ffmpeg

# Get OBS screen recording software
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update
sudo apt-get install obs-studio

# Download OF and compile from source
echo "Downloading and installing to $OPENFRAMEWORKS_DIR"
echo "This will take a while..."
git clone --recursive git@github.com:openframeworks/openFrameworks.git $OPENFRAMEWORKS_DIR

# Build stuff
cd $OPENFRAMEWORKS_DIR
sudo ./scripts/linux/ubuntu/install_dependencies.sh
sudo ./scripts/linux/ubuntu/install_codecs.sh
sudo ./scripts/linux/download_libs.sh

# Submodules - specifically for ./apps/projectGenerator
git submodule init
git submodule update

cd $HERE
