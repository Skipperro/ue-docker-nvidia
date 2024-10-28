#!/bin/bash

# Start Xvfb in the background
rm -rf /tmp/.X1-lock
Xvfb :1 -screen 1 1920x1080x24 &

# Wait for Xvfb to start
sleep 1

# Set DISPLAY environment variable
export DISPLAY=:1

# Start x11vnc in the background
x11vnc -display :1 -nopw -forever -shared -ncache 10 -rfbport 5566 &

# Start noVNC in the background
/opt/noVNC/utils/novnc_proxy --vnc localhost:5566 --listen 5678 &

# Start the application
cd /app
exec sh run_app.sh "$RUN_ARGS" "$@"

