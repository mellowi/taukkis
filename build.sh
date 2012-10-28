#!/bin/sh

# remove old
rm -rf ../apps4finlands-build

# compile coffee
for i in `find js -maxdepth 4 -mindepth 0 -type f -name "*.coffee"`; do
	file=$i
	name=${file%.*}
	coffee --compile $i
	sed -i -e's/cs\!//g' $name.js
done

# optimize
node js/r.js -o js/build.js

# remove not needed files
rm -R -rf ../apps4finlands-build/.git
rm -rf ../apps4finlands-build/.gitignore
rm -rf ../apps4finlands-build/build.sh
rm -rf ../apps4finlands-build/build.txt
rm -rf ../apps4finlands-build/README.md
rm -rf ../apps4finlands-build/js/libs/modernizr-2.5.3.js
rm -rf ../apps4finlands-build/js/libs/jquery-1.8.0.js
rm -rf ../apps4finlands-build/js/libs/lodash-0.4.2.js
rm -rf ../apps4finlands-build/js/libs/backbone-0.9.2.js
rm -rf ../apps4finlands-build/js/libs/RouteBoxer.js
rm -rf ../apps4finlands-build/js/libs/OpenLayers.mobile.js
#rm -rf ../apps4finlands-build/js/settings.js

# remove the coffee file from prod
for i in `find js -maxdepth 2 -mindepth 0 -type f -name "*.coffee"`; do
	file=$i
	name=${file%.*}
	rm -rf $name.js
	rm -rf ../apps4finlands-build/$i
done

# dev coffee removed
rm -rf ../apps4finlands-build/js/libs/cs.js
rm -rf ../apps4finlands-build/js/libs/coffee-script.js
