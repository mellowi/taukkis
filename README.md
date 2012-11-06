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

USING LIGHTTPD AS REVERSE PROXY
===============================

Copy lighty.conf.template to lighty.conf and edit the root path.  Start app.py
in its default port (8022) and run lighttpd as follows:

  lighttpd -f lighty.conf -D

