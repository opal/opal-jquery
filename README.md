# opal-jquery

[![Build Status](https://secure.travis-ci.org/opal/opal-jquery.png?branch=master)](http://travis-ci.org/opal/opal-jquery)

opal-jquery provides DOM access to opal by wrapping jquery
and providing a nice ruby syntax for dealing with jquery instances.
opal-jquery is [hosted on github](http://github.com/opal/opal-jquery).

See the [website for documentation](http://opal.github.com/opal-jquery).

## Running Specs

Get the dependencies:

    $ bundle install

Build dependencies, opal-jquery and it's specs into `build/`:

    $ rake opal

Run the tests inside a phantom.js runner:

    $ rake

##  License

Copyright (C) 2012 by Adam Beynon

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.