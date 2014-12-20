TARGET   = oaf-std-qt4
TEMPLATE = lib

#
# Explicitly link with the Qt WebKit module
#
QT += webkit xml

#
# Qt5-specific configuration options
#
greaterThan(QT_MAJOR_VERSION, 4) {
	QT += concurrent
	QT += widgets
}

#
# Build configuration
#
CONFIG += qt thread warn_on

#
# Dynamic linking configuration for the library under Windows
#
win32:CONFIG  += dll
win32:DEFINES += OAFSTD_LIBRARY

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
# OAF-ROOT
#
TOPSRCDIR    = ../..
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
# OAF-GIT2
#
INCLUDEPATH  += $${TOPSRCDIR}/libs/liboaf-git2/include
LIBS         += -L$${TOPSRCDIR}/libs/liboaf-git2/$${buildmode} -loaf-git2

#
# Additional C++ header search path
#
INCLUDEPATH += include

#
# C++ Headers list
#
HEADERS += \
	include/OAF/OafStdGlobal.h \
	include/OAF/CTreeNode.h \
	include/OAF/CRecentFiles.h \
	include/OAF/Helpers.h \
	include/OAF/HelpersTXT.h \
	include/OAF/diff_match_patch.h \
	include/OAF/HtmlHelpers.h \
	include/OAF/ExchangeHelpers.h \
	include/OAF/MimeHelpers.h \
	include/OAF/IconHelpers.h \
	include/OAF/CProgressWatcher.h \
	include/OAF/CGitUrl.h \
	include/OAF/Consts.h

#
# C++ Sources list
#
SOURCES += \
	src/CTreeNode.cpp \
	src/CRecentFiles.cpp \
	src/Helpers.cpp \
	src/HelpersTXT.cpp \
	src/diff_match_patch.cpp \
	src/HtmlHelpers.cpp \
	src/ExchangeHelpers.cpp \
	src/MimeHelpers.cpp \
	src/IconHelpers.cpp \
	src/CProgressWatcher.cpp \
	src/CGitUrl.cpp
