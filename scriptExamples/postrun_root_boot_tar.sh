#!/bin/bash

COMPRESSION_FORMAT=${COMPRESSION_FORMAT=".gz"}

echo "Archiving rootfs..."
tar -p -c -f "dist/Rootfs.tar"$COMPRESSION_FORMAT -C dist/rootfs .

echo "Archiving boot..."
tar -c -f "dist/Boot.tar"$COMPRESSION_FORMAT -C dist/boot .
