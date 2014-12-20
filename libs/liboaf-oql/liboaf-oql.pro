TARGET   = oaf-oql-qt4
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
win32:DEFINES += OAFOQL_LIBRARY

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
# For build under Microsoft Visual C++ we need to disable unistd.h
# header usage in bison
#
win32-msvc*:DEFINES += YY_NO_UNISTD_H

#
# For build under Microsoft Visual C++ we need explicitly
# setup bison parameters: path to it, output file names, etc.
#
win32-msvc* {
	QMAKE_YACC             = bison
	QMAKE_YACCFLAGS_MANGLE = -p OQLGram -b OQLGram
	QMAKE_YACC_HEADER      = ${QMAKE_FILE_BASE}.tab.h
	QMAKE_YACC_SOURCE      = ${QMAKE_FILE_BASE}.tab.c
	QMAKE_MOVE             = copy
}

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
# Additional C++ header search path
#
INCLUDEPATH += include

#
# C++ Headers list
#
HEADERS += \
	include/OAF/OafOqlGlobal.h \
	include/OAF/CExpression.h \
	include/OAF/OQL.h

#
# C++ Sources list
#
SOURCES += \
	src/CExpression.cpp

#
# OQL programming language scanner and parser source code
#
LEXSOURCES  += src/OQLscan.l
YACCSOURCES += src/OQLgram.y
