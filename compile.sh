#!/bin/bash

# ! COPY "compile.sh" INTO YOUR KERNEL DIRECTORY AND START COMPILING BY USING "bash compile.sh" COMMAND.

#  [ 2021 - 2022 ]

NC='\033[0m'
R='\033[1;31m'
P='\033[0;35m'

export KBUILD_BUILD_VERSION= # Build version.
export KBUILD_COMPILER_STRING= # ex: "**** clang version 15.0.0"
export KBUILD_BUILD_USER= # Change with your own name.
export KBUILD_BUILD_HOST= # Change with your own hostname.

# Interface
echo ================================================
echo -e "${R}Ace-KernelCompiler${NC}"
echo version : 2.0
echo ================================================
echo -e "BUILD VERSION =${P} ${KBUILD_BUILD_VERSION}${NC}"
echo -e "CUSTOM COMPILER NAME =${P} ${KBUILD_COMPILER_STRING}${NC}"
echo -e "BUILDER NAME =${P} ${KBUILD_BUILD_USER}${NC}"
echo -e "BUILDER HOSTNAME =${P} ${KBUILD_BUILD_HOST}${NC}"
echo ================================================
echo 
sleep 3

# Compile | MODIFY ACCORDING TO YOUR DEVICE.
mkdir out
export ARCH=arm64
export SUBARCH=arm64
export DTC_EXT=dtc
make O=out ARCH=arm64 device_defconfig # ! Replace "device_defconfig" with your kernel source defconfig for example: "lancelot_defconfig"
export PATH="${PWD}/CLANG_NAME/bin:${PATH}" # ! Replace "CLANG_NAME" with your clang folder name for example: "google-clang"
make -j$(nproc --all) O=out \
                  ARCH=arm64 \
                  CC=clang \
                  CROSS_COMPILE=aarch64-linux-gnu- \
                  CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                  LD=ld.lld \
                  AR=llvm-ar \
                  AS=llvm-as \
                  NM=llvm-nm \
                  OBJCOPY=llvm-objcopy \
                  OBJDUMP=llvm-objdump \
                  STRIP=llvm-strip 
bp=${PWD}/out
DATE=$(date "+%m%d-%H%M")
ZIPNAME="KERNEL" # Compiled .zip name
cd ${PWD}/AnyKernel3 # AnyKernel3 installer
rm *.zip *-dtb 
cp $bp/arch/arm64/boot/Image.gz-dtb .
zip -r9 "$ZIPNAME"-"${DATE}".zip *
cd - || exit
