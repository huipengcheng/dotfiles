#!/usr/bin/env bash

# 如果系统目录存在，且不是软链接，说明是包管理器建的，我们把它删掉/备份
if [ -d "/etc/keyd" ] && [ ! -L "/etc/keyd" ]; then
    echo "Removing existing /etc/keyd directory so Stow can link the whole directory..."
    sudo rm -rf /etc/keyd
fi
