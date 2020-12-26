#!/bin/sh

# convert -resize '300x300!' -strip -interlace Plane -quality 80 $1 $1-out.jpg

# faster
for image in $(find ../docs/.vuepress/public/media/ -regex '.*\.\w\w\w$'); do 
    convert -thumbnail '400x400!' -strip -interlace Plane -quality 80 $image $image
done
# convert -thumbnail '400x400!' -strip -interlace Plane -quality 80 $1 $1