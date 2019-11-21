project(
    'sugarmate',
    'vala', 'c',
    version: '2.1.3'
)

gettext_name = meson.project_name() + '-indicator'

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

wingpanel_dep = dependency('wingpanel-2.0', version: '>=2.1.0')
wingpanel_indicatorsdir = wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

shared_module(
    meson.project_name(),
    'src/Indicator.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('libnotify'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        wingpanel_dep
    ],
    install: true,
    install_dir : wingpanel_indicatorsdir,
)
