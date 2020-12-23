#!/bin/sh

convert -resize '300x300!' -strip -interlace Plane -quality 80 $1 $1-out.jpg

# faster
convert -thumbnail '400x400!' -strip -interlace Plane -quality 80 $1 $1-out