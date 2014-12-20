TARGET   = oaf-qt4
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
CONFIG += qt thread warn_on

#
# Dynamic linking configuration for the library under Windows
#
win32:CONFIG  += dll
win32:DEFINES += OAF_LIBRARY

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
	isEmpty(LIBRARY_INSTALL_PATH):LIBRARY_INSTALL_PATH = /bin
}
else {
	isEmpty(LIBRARY_INSTALL_PATH):LIBRARY_INSTALL_PATH = /usr/lib/oaf-qt4
}

#
# Library installation target configuration
#
target.path = $${LIBRARY_INSTALL_PATH}

#
# Installation targets configuration
#
INSTALLS += target

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
# Additional C++ header search path
#
INCLUDEPATH += include

#
# C++ Headers list
#
HEADERS += \
	include/OAF/OafGlobal.h \
	include/OAF/OAF.h \
	src/CClassInfo.h \
	src/CFunctionFactory.h

#
# C++ Sources list
#
SOURCES += \
	src/OAF.cpp \
	src/CClassInfo.cpp \
	src/CFunctionFactory.cpp
