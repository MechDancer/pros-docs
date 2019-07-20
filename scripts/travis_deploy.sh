#!/bin/bash

mkdir res
echo 'pros.mechdancer.org'>build/v5-chinese/html/CNAME
cp -rf ./build/v5-chinese/html/* ./res/
touch ./res/.nojekyll
