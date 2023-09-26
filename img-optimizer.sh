#!/bin/bash

# --------------------------------------------------
# DESCRIPTION
# --------------------------------------------------
#
# Create multiple sizes, converts and optimizes the images
# for web
#
# --------------------------------------------------
# INSTRUCTION
# --------------------------------------------------
#
# Usage: ./img-optimizer.sh
#
# --------------------------------------------------
#
# Dependencies
# ImageMagick https://imagemagick.org/
# optipng
# jpegoptim
#
# --------------------------------------------------

# Function to resize images
function resize_image {
    local image=$1
    local sizes=( 384 512 768 1024 1920 )
    local width=$(identify -format "%w" "$image")
    local extension="${image##*.}"
    echo "Processing $image file..."
    for size in ${sizes[@]}; do
        [ $width -gt $size ] && magick "$image" -resize ${size} -strip "./${image%.${extension}}-${size}w.${extension}"
    done
}

# Function to convert images
function convert_image {
    local image=$1
    local extension="${image##*.}"
    magick "$image" -strip "./optimized/${image%.${extension}}.webp"
    magick "$image" -strip "./optimized/${image%.${extension}}.avif"
}

# Function to optimize images
function optimize_image {
    local image=$1
    local extension="${image##*.}"
    case $extension in
        jpg|jpeg)
            jpegoptim -d "./optimized/${image}" "$image"
            ;;
        png)
            optipng -out "./optimized/${image}" "$image"
            ;;
    esac
}

# Main script
[ ! -d "optimized" ] && mkdir "optimized"
for image in *.{jpg,jpeg,png}; do
    resize_image "$image"
done

for image in *.{jpg,jpeg,png}; do
    convert_image "$image"
    optimize_image "$image"
    rm "$image"
done