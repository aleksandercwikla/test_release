#!/bin/bash

anaconda login

# Only need to change these two variables
PKG_NAME=test_release
USER=acwikla-novela

OS=$TRAVIS_OS_NAME-64

mkdir ~/conda-bld

conda config --set anaconda_upload no
export CONDA_BLD_PATH=~/conda-bld
export VERSION=123

echo "Building conda package..."
cd $RECIPE_DIR/..  || exit
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
conda build .
#ToDO Change date to version

echo "bld"
ls $CONDA_BLD_PATH/
echo "linux"
ls $CONDA_BLD_PATH/linux-64/
echo "Converting conda package..."
conda convert --platform all $CONDA_BLD_PATH/linux-64/$PKG_NAME-$VERSION.tar.bz2 --output-dir $CONDA_BLD_PATH/
ls $CONDA_BLD_PATH/linux-64/

echo "Deploying to Anaconda.org..."
anaconda -t $CONDA_UPLOAD_TOKEN upload $CONDA_BLD_PATH/**/$PKG_NAME-$VERSION.tar.bz2 --force