#!/bin/bash
GameServer=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$DIR/generateSproto/"
./lua MergeNetMsg.lua $GameServer #合并协议文件

# 发布的 目录文件
TARGET_BYTE_DIR="$DIR/bin/netmsg.bin"
TARGET_CS_DIR="$DIR/bin/netmsg.cs"

# 生成js使用的spb
# ./lua sprotodump.lua -spb2 netmsg -o $TARGET_BYTE_DIR

# 生成C#
./lua sprotodump.lua -cs netmsgCS -o $TARGET_CS_DIR