#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#173559/g' \
         -e 's/rgb(100%,100%,100%)/#E3D1D1/g' \
    -e 's/rgb(50%,0%,0%)/#173559/g' \
     -e 's/rgb(0%,50%,0%)/#326E95/g' \
 -e 's/rgb(0%,50.196078%,0%)/#326E95/g' \
     -e 's/rgb(50%,0%,50%)/#173559/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#173559/g' \
     -e 's/rgb(0%,0%,50%)/#E3D1D1/g' \
	*.svg