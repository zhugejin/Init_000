HERE=$PWD
DEFAULT_ROOT_DIR=$HOME
NPROCS=3

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

# Compile openFrameworks and projectGenerator
./scripts/linux/compileOF.sh -j$NPROC
./scripts/linux/compilePG.sh -j$NPROC

# The following was pulled from ./apps/projectGenerator/scripts/linux/buildPG.sh
# Build projectGenerator
cd ${OPENFRAMEWORKS_DIR}/apps/projectGenerator
make Release -C ./commandLine
ret=$?
if [ $ret -ne 0 ]; then
      echo "Failed building Project Generator"
      exit 1
fi

# 
echo "${TRAVIS_REPO_SLUG}/${TRAVIS_BRANCH}";
if [ "${TRAVIS_REPO_SLUG}/${TRAVIS_BRANCH}" = "openframeworks/projectGenerator/master" ] && [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    openssl aes-256-cbc -K $encrypted_cd38768cbb9d_key -iv $encrypted_cd38768cbb9d_iv -in scripts/id_rsa.enc -out scripts/id_rsa -d
    cp scripts/ssh_config ~/.ssh/config
    chmod 600 scripts/id_rsa
    scp -i scripts/id_rsa commandLine/bin/projectGenerator tests@198.61.170.130:projectGenerator_builds/projectGenerator_linux_new
    ssh -i scripts/id_rsa tests@198.61.170.130 "mv projectGenerator_builds/projectGenerator_linux_new projectGenerator_builds/projectGenerator_linux"
fi
rm -rf scripts/id_rsa


cd $HERE

echo "To make a project, navigate to its directory, and type:"
echo "make"
echo "make run"
