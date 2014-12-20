TARGET   = oaf-std-1.0
TEMPLATE = lib

#
# Qt5-specific configuration options
#
greaterThan(QT_MAJOR_VERSION, 4) {
	QT += concurrent
}

#
# Build configuration
#
CONFIG += qt thread warn_on plugin

#
# Flags for the correct RTTI work under Unix-like operating systems
#
# NOTE: These flags must be used in all system components:
# libraries, plugins, application
#
unix:QMAKE_LFLAGS += -Wl,-E

#
# Build mode configuration (release by default)
#
buildmode = release
CONFIG(debug, debug|release):buildmode = debug

#
# Build directories configation depending on the build mode
#
DESTDIR     = $${buildmode}
UI_DIR      = $${buildmode}
OBJECTS_DIR = $${buildmode}
MOC_DIR     = $${buildmode}

#
# Install directory for the compiled library files configuration
#
win32 {
	isEmpty(PLUGIN_INSTALL_PATH):PLUGIN_INSTALL_PATH = /bin/plugins
}
else {
	isEmpty(PLUGIN_INSTALL_PATH):PLUGIN_INSTALL_PATH = /usr/lib/oaf-qt4/plugins
}

#
# Library installation target configuration
#
target.path = $${PLUGIN_INSTALL_PATH}

#
# OAF-file installation target configuration
#
oaf.files = liboaf-std-1.0.oaf
oaf.path  = $${PLUGIN_INSTALL_PATH}

#
# Installation targets configuration
#
INSTALLS += target oaf

#
# Copy OAF-file to the library build directory
#
system($$QMAKE_MKDIR $$buildmode)
system($$QMAKE_COPY *.oaf $$buildmode)

#
# ROOT
#
TOPSRCDIR    = ../../
INCLUDEPATH += $${TOPSRCDIR}

#
# OAF-CORE
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-core/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-core/$${buildmode} -loaf-core-qt4

#
# OAF-OQL
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-oql/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-oql/$${buildmode} -loaf-oql-qt4

#
# OAF
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf/$${buildmode} -loaf-qt4

#
# OAF-STD
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-std/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-std/$${buildmode} -loaf-std-qt4

#
# Include libOAF version information
#
include ($${TOPSRCDIR}/liboaf_version.pri)

#
# C++ Headers list
#
HEADERS += \
	src/CCommon.h \
	src/CFactory.h \
	src/CMonikerSTD.h

#
# C++ Sources list
#
SOURCES += \
	src/CCommon.cpp \
	src/CFactory.cpp \
	src/CMonikerSTD.cpp \
	src/main.cpp
