# copadocs

CoPaDocs – Corpus of Patient Documents – source files

This repository saves patient texts from the
[CoPaDocs](http://copadocs.de/) project.

All data is provided via [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/),
except for third party web libraries, like jQuery, Bootstrap, Datatables,
and others, which are part of this repository to provide a complete package
for serving a static website in compliance with the GDPR.

## Preview via GitHub Pages

A preview is available at https://deutschestextarchiv.github.io/copadocs/.

## Software prerequisites

* [jq](https://stedolan.github.io/jq/)
* [xsltproc](http://xmlsoft.org/xslt/xsltproc.html)

Installation on Debian-like systems (Debian GNU/Linux, Ubuntu, Linux Mint etc.):

```bash
sudo apt install jq xsltproc
```

## Setup instructions

To generate all data needed for HTML presentation, just execute

```bash
./build.sh
```

## Webserver setup

You’ll need a webserver to serve the HTML files.
A setup for Apache may look like:

```apacheconf
<Directory /your/path/to/copadocs/web>
  DirectoryIndex index.html
  Options +Indexes
  Require all granted
</Directory>
Alias /copadocs /your/path/to/copadocs/web
```

## Contact

Frank Wiegand, <mailto:wiegand@bbaw.de>
