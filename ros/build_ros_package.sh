#!/bin/sh -x

#===============================================================================

SRCDIR=`pwd`
OS_BUILDDIR=$SRCDIR/iPhoneOS_build
SIMULATOR_BUILDDIR=$SRCDIR/iPhoneSimulator_build
PACKAGE_NAME=`basename $1`

#===============================================================================
echo "Checking for messages or services ..."

#TODO: parse the manifest to get messages dependencies
if [ -d $1/msg ] || [ -d $1/srv ];
    then
        (cd $SRCDIR/ros_msgs/; sh $SRCDIR/ros_msgs/messages_gen.sh -d $1 $SRCDIR/ros_msgs/std_msgs);
        mv $SRCDIR/ros_msgs/$PACKAGE_NAME/*.h $1/include/$PACKAGE_NAME/
        rm -r $SRCDIR/ros_msgs/$PACKAGE_NAME/
fi

#===============================================================================
echo "Generating cmake submodules ..."

sh $SRCDIR/cmake_gen.sh $*

#===============================================================================
echo "Generating CMakeLists.txt ..."

cat > CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 2.8.0)

set (CMAKE_FRAMEWORK_PATH \${CMAKE_SYSTEM_FRAMEWORK_PATH} $SRCDIR/frameworks)

project($PACKAGE_NAME)

include($PACKAGE_NAME.cmake)

EOF

#===============================================================================
echo "Building ..."

[ -d $OS_BUILDDIR ] && rm -rf $OS_BUILDDIR
[ -d $SIMULATOR_BUILDDIR ] && rm -rf $SIMULATOR_BUILDDIR

mkdir $OS_BUILDDIR
mkdir $SIMULATOR_BUILDDIR

cd $OS_BUILDDIR

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$SRCDIR/ios_cmake/Toolchains/Toolchain-iPhoneOS_Xcode.cmake -DCMAKE_INSTALL_PREFIX=ros_iPhoneOS -GXcode ..

xcodebuild -sdk iphoneos -configuration Release -target ALL_BUILD

cd $SIMULATOR_BUILDDIR

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$SRCDIR/ios_cmake/Toolchains/Toolchain-iPhoneSimulator_Xcode.cmake -DCMAKE_INSTALL_PREFIX=ros_iPhoneSimulator -GXcode ..

xcodebuild -sdk iphonesimulator -configuration Release -target ALL_BUILD

#===============================================================================
cd $SRCDIR
FRAMEWORK_NAME=`basename $1`

sh framework_gen.sh $FRAMEWORK_NAME $OS_BUILDDIR/Release-iphoneos $SIMULATOR_BUILDDIR/Release-iphonesimulator $1/include/$FRAMEWORK_NAME/

echo "build_package : done !"
