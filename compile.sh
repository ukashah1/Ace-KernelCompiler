#!/bin/bash

# ! COPY "compile.sh" INTO YOUR KERNEL DIRECTORY AND START COMPILING BY USING "bash compile.sh" COMMAND.

# Code
NC='\033[0m'
R='\033[1;31m'
P='\033[0;35m'

export KBUILD_BUILD_USER= # Change with your own name.
export KBUILD_BUILD_HOST= # Change with your own hostname.

# Interface
echo ================================================
echo -e "${R}Ace-KernelCompiler${NC}"
echo version : 1.0
echo ================================================
echo -e "BUILDER NAME =${P} ${KBUILD_BUILD_USER}${NC}"
echo -e "BUILDER HOSTNAME =${P} ${KBUILD_BUILD_HOST}${NC}"
echo ================================================
echo 
sleep 3

# Compile
mkdir out
make -j$(nproc) O=out ARCH=arm64 INSERT # ! Replace "INSERT" with your kernel source defconfig for example: "lancelot_defconfig"
export PATH="${PWD}/CLANG_NAME/bin:${PATH}" # ! Replace "CLANG_NAME" with your clang for example: "ace-clang"
make -j$(nproc) ARCH=arm64 O=out \
                  CC=clang \
                  CROSS_COMPILE=aarch64-linux-gnu- \
                  CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                  LD=ld.lld \
                  AS=llvm-as \
                  NM=llvm-nm \
                  OBJCOPY=llvm-objcopy \
                  OBJDUMP=llvm-objdump \
                  STRIP=llvm-strip 
bp=${PWD}/outL
DATE=$(date "+%m%d-%H%M")
ZIPNAME="KERNEL" # Output name
cd ${PWD}/AnyKernel3-master
rm *.zip *-dtb 
cp $bp/arch/arm64/boot/Image.gz-dtb .
zip -r9 "$ZIPNAME"-"${DATE}".zip *
cd - || exit
