#!/bin/bash

mkdir res
touch build/v5-chinese/html/.nojekyll
echo 'pros.mechdancer.org'>build/v5-chinese/html/CNAME
cp -rf ./build/v5-chinese/html/* ./res/