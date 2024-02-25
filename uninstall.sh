#!/bin/sh

# The script removes Luke Smith st, dwm, dwmblocks, and dmenu from OpenBSD

LOCDIR=/usr/local
BINDIR=$LOCDIR/bin
MANDIR=$LOCDIR/share/man/man1

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

if [ -z "$1" ]; then
	echo "Provide your user"
	echo "Example: curl -sL [URL] | doas sh -s mike"
	exit 1
fi

rm -rf $BINDIR/st $BINDIR/st-copyout $BINDIR/st-urlhandler $MANDIR/st.1 \
$BINDIR/dwmblocks $BINDIR/dwm $LOCDIR/share/dwm/ $MANDIR/dwm.1 \
$BINDIR/dmenu $BINDIR/dmenu_path $BINDIR/dmenu_run $BINDIR/stest \
$MANDIR/dmenu.1 $MANDIR/stest.1 && \
([[ -f /home/$1/.xsession.bak ]] && mv /home/$1/.xsession.bak /home/$1/.xsession || \
rm -f /home/$1/.xsession) && echo "Removed dwm dwmblocks dmenu and st" && \
echo "Restart your machine" || (echo "Uninstallation process failed" && exit 1)
