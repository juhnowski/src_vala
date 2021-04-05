dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(streamax, 0.1)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC

AM_PROG_AR

AM_PROG_VALAC


dnl ***************************************************************************
dnl Internationalization
dnl ***************************************************************************
IT_PROG_INTLTOOL([0.35.0])

GETTEXT_PACKAGE=streamax
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE", [GETTEXT package name])
AM_GLIB_GNU_GETTEXT





LT_INIT


pkg_modules="gobject-2.0 "
AC_SUBST(pkg_modules)
PKG_CHECK_MODULES(STREAMAX, [gobject-2.0 ])





AC_OUTPUT([
Makefile
src/streamax-0.1.pc
src/Makefile
po/Makefile.in])
