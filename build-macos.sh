#!/bin/bash

# Build macOS universal binary CLAP plugin.
# The `Nuked-SC55.clap` app bundle will created in the `out` directory.
#
# Expects VCPKG_ROOT to be set and vcpkg in the path (see README).
#

rm -rf out
mkdir out

# Build arm64 release version
rm -rf build
cmake --preset=release -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build --preset=release
mv build/release/Nuked-SC55.clap out

# Build x86_64 release version
rm -rf build
cmake --preset=release -DCMAKE_OSX_ARCHITECTURES=x86_64
cmake --build build --preset=release
cp build/release/Nuked-SC55.clap/Contents/MacOS/Nuked-SC55 out/Nuked-SC55-x86_64

# Create universal binary
lipo out/Nuked-SC55-x86_64 \
	 out/Nuked-SC55.clap/Contents/MacOS/Nuked-SC55 \
	 -create -output out/Nuked-SC55

rm out/Nuked-SC55-x86_64
rm out/Nuked-SC55.clap/Contents/MacOS/Nuked-SC55

mv out/Nuked-SC55 out/Nuked-SC55.clap/Contents/MacOS/

# Verify
echo
echo "----------------------------------------------------------------------"

ARCHS=`lipo -archs out/Nuked-SC55.clap/Contents/MacOS/Nuked-SC55`

if [ "$ARCHS" == "x86_64 arm64" ]; then
	echo "Success! Universal binary app bundle is in 'out/Nuked-SC55.clap'"
else
	echo "Oops, something went wrong. Arch of the CLAP plugin is '$ARCHS'"
fi
