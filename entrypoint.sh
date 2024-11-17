#!/bin/bash

# Start Xvfb in the background
#rm -rf /tmp/.X1-lock
#Xvfb :1 -screen 1 1920x1080x24 &

# Wait for Xvfb to start
sleep 1

# Set DISPLAY environment variable
export DISPLAY=:1

# Start XPRA
xpra stop :4 2>/dev/null

exec xpra start :4 \
    --bind-tcp=0.0.0.0:5566 \
    --tray=yes \
    --start-new-commands=no \
    --html=on \
    --file-transfer=no \
    --open-files=no \
    --bandwidth-limit=20000000 \
    --clipboard=no \
    --webcam=no \
    --speaker=on \
    --microphone=off \
    --encoding=x264 \
    --video-encoders=nvenc \
    --quality=55 \
    --refresh-rate=60 \
    --opengl=no \
    --exit-with-children \
    --daemon=no \
    --desktop-fullscreen=yes \
    --desktop-scaling=1920x1080 \
    --audio-source=alsasrc \
    --pulseaudio=yes \
    --start-child="/app/tps-demo.x86_64"


# Start the application
#cd /app
#exec sh /run_app.sh "$RUN_ARGS" "$@"
