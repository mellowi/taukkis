NOTICES
=======
build @ ../apps4finlands-build

LIBRARIES
=========
jquery
backbone
underscore (req. backbone)
lodash (req. backbone <=> require.js)
require.js
modernizer
twitter bootstrap

BUILD TOOL
==========
./build.sh (req node)

KNOWN ISSUES
============

- does not work over file-protocol (cross-domain policy)
  --> python -m SimpleHTTPServer
- does not work on Opera 12.02 (newest as of 7.10.2012) (jquery-1.8.0.js is not compatible)