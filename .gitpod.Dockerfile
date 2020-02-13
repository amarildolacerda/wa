FROM emscripten/emscripten-ci

USER gitpod

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/

RUN sudo apt-get update && apt-get install autoconf libtool gettext autogen imagemagick libmagickcore-dev -y


RUN sudo mkdir /src

# cd into the mounted host directory
RUN cd /src

# clone the latest ZBar code from the Github repo
RUN sudo git clone https://github.com/ZBar/ZBar

# cd into the directory
RUN cd ZBar

# Delete all -Werror strings from configure.ac
# Don't treat warnings as errors!
RUN sudo sed -i "s/ -Werror//" $(pwd)/configure.ac

# Generate automake files
RUN sudo autoreconf -i

# Configure: disable all unneccesary features
# This may produce red error messages, but it is safe to ignore them (it assumes that
# emscripten is GCC and uses invalid parameters on it)
RUN sudo emconfigure ./configure --without-x --without-jpeg --without-imagemagick --without-npapi --without-gtk --without-python --without-qt --without-xshm --disable-video --disable-pthread

# Compile ZBar
RUN sudo emmake make
