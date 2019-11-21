# Wingpanel Sugarmate Indicator

Displays current blood glucose reading and trend from Sugarmate

## Building and Installation

You'll need the following dependencies:

    libcanberra-gtk-dev
    libgranite-dev
    libglib2.0-dev
    libgtk-3-dev
    libnotify-dev
    libwingpanel-2.0-dev >= 2.1.0
    libsoup-2.4
    json-glib-1.0
    meson
    valac (>= 0.26)

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    sudo ninja install
