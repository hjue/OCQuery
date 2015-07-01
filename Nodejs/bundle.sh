#!/bin/sh
#browserify index.js -o ../OCQuery/Javascript/app.js
browserify index.js |uglifyjs  -o ../OCQuery/Javascript/app.js