#!/bin/bash

# Only need to change these two variables
PKG_NAME=test_release
USER=acwikla-novela
VERSION=0.0.001

OS=$TRAVIS_OS_NAME-64

mkdir ~/conda-bld

conda config --set anaconda_upload no
export PKG_NAME=test_release
export CONDA_BLD_PATH=~/conda-bld
export VERSION=0.0.001

echo "Building conda package..."
#cd $RECIPE_DIR/..  || exit
conda build .
#ToDO Change date to version

echo "ls bld path"
ls $CONDA_BLD_PATH/
echo "ls linux-64"
ls $CONDA_BLD_PATH/linux-64/
echo "Converting conda package..."
conda convert --platform all $CONDA_BLD_PATH/linux-64/$PKG_NAME-$VERSION.tar.bz2 --output-dir $CONDA_BLD_PATH/
ls $CONDA_BLD_PATH/linux-64/

echo "Deploying to Anaconda.org..."
anaconda -t $CONDA_UPLOAD_TOKEN upload $CONDA_BLD_PATH/**/$PKG_NAME-$VERSION.tar.bz2 --force