#!/bin/bash

stow -t $HOME --ignore='^etc$' .
sudo stow -t /etc etc
