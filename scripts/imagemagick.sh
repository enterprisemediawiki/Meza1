#!/bin/sh
#
# Install ImageMagick, Ghostscript and Xpdf

print_title "Starting script imagemagick.sh"


if [ "$(whoami)" != "root" ]; then
	echo "Try running this script with sudo: \"sudo bash imagemagick.sh\""
	exit 1
fi

cd "$m_meza/sources"
git clone https://github.com/enterprisemediawiki/meza-packages
cd meza-packages/RPMs
yum install -y ./imagemagick_7.0.3_x86_64.rpm


# For testing should run: `make check`


# Get xpdf-utils
echo "Download xpdf-utils"
cd ~/mezadownloads
wget http://mirror.unl.edu/ctan/support/xpdf/xpdfbin-linux-3.04.tar.gz
tar xvzf xpdfbin-linux-3.04.tar.gz

cd xpdfbin-linux-3.04

# Copy correct-architecture executables to /usr/local/bin
if [ $(uname -m | grep -c 64) -eq 1 ]; then
	echo "Move 64-bit executables to /usr/local/bin"
	cp -a ./bin64/. /usr/local/bin/
else
	echo "Move 32-bit executables to /usr/local/bin"
	cp -a ./bin32/. /usr/local/bin/
fi

# CentOS does not have /usr/local/man, but xpdf recommends the following
# copy man pages and sample
# note: sample is entirely commented out and requires modification
# cp ./doc/*.1 /usr/local/man/man1
# cp ./doc/*.5 /usr/local/man/man5
# cp ./doc/sample-xpdfrc /usr/local/etc/xpdfrc

