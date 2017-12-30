#!/bin/sh
USER=ubuntu
HOST=www.apower.top
DIR=documents/blog   # might sometimes be empty!

hugo && rsync -avz --delete public/ ${USER}@${HOST}:~/${DIR}

exit 0