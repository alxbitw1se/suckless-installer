#!/bin/sh

# The script apply some minor patches to make
# Luke Smith st, dwm, dwmblocks, and dmenu 
# to compile and install on OpenBSD
# This is a POC, use at your risks
# Some of the runtime packages or void rice stuff may be missing
# known issues:
#   - dwmblcoks missing void rice config and scripts
#   - no emoji

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

if [ -z "$1" ]; then
	echo "Provide your user"
	echo "Example: curl -sL [URL] | doas sh -s mike"
	exit 1
fi

install_deps() {
    pkg_add git freetype harfbuzz
}

clean_up() {
    rm -rf /tmp/st/ /tmp/dwm/ /tmp/dwmblocks/ /tmp/dmenu/ 
}

clone_repos() {
    git clone --quiet https://github.com/LukeSmithxyz/st.git /tmp/st && \
    git clone --quiet https://github.com/LukeSmithxyz/dwm.git /tmp/dwm && \ 
    git clone --quiet https://github.com/LukeSmithxyz/dwmblocks.git /tmp/dwmblocks && \
    git clone --quiet https://github.com/LukeSmithxyz/dmenu.git /tmp/dmenu || \
    (echo "Repos cloning failed" && false)
}

apply_patches() {
    curl -sL https://git.io/JE2qf > /tmp/st/config.mk && \
    curl -sL https://git.io/JE2qm > /tmp/dmenu/config.mk && \
    curl -sL https://git.io/JE2qZ > /tmp/dwmblocks/Makefile && \
    curl -sL https://git.io/JE2qW > /tmp/dwm/config.mk || (echo "Failed to apply patches" && false)
}

compile_install() {
    make -C /tmp/st && make install -C /tmp/st || (echo "Failed to install st" && false) && \
    make -C /tmp/dmenu && make install -C /tmp/dmenu || (echo "Failed to install dmenu" && false) && \
    make -C /tmp/dwmblocks && make install -C /tmp/dwmblocks || (echo "Failed to install dwmblocks" && false) && \
    make -C /tmp/dwm && make install -C /tmp/dwm || (echo "Failed to install dwm" && false)
}

clean_up && install_deps && clone_repos && apply_patches && compile_install && \
([[ -f /home/$1/.xsession ]] && mv /home/$1/.xsession /home/$1/.xsession.bak && \
echo "exec dwm" > "/home/$1/.xsession" || echo "exec dwm" > "/home/$1/.xsession") && \ 
clean_up && echo "Successfully installed dwm & dwmblocks & dmenu & st" && \
echo "Restart your machine" || \
(echo "Installation process failed" && exit 1)
