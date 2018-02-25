#!/bin/bash

compressor=xz
compressor_args="-z -e"

$compressor $compressor_args $IMGFILE
