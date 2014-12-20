TARGET   = oaf-gui-qt4
TEMPLATE = lib

#
# Explicitly link with the Qt WebKit module
#
QT += webkit xml

#
# Qt5-specific configuration options
#
greaterThan( QT_MAJOR_VERSION, 4 ) {
	QT += widgets
	QT += webkitwidgets
}

#
# Build configuration
#
CONFIG += qt thread warn_on

#
# Dynamic linking configuration for the library under Windows
#
win32:CONFIG  += dll
win32:DEFINES += OAFGUI_LIBRARY

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
# OAF-STD
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-std/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-std/$${buildmode} -loaf-std-qt4

#
# Additional C++ header search path
#
INCLUDEPATH += include

#
# C++ Headers list
#
HEADERS += \
	include/OAF/OafGuiGlobal.h \
	include/OAF/CLineEdit.h \
	include/OAF/CTabWidget.h \
	include/OAF/CUIContainer.h \
	include/OAF/CUIManager.h \
	include/OAF/DockResizeHelper.h \
	include/OAF/ViewFindHelper.h \
	include/OAF/CSearchLineWidget.h \
	include/OAF/CWebView.h \
	include/OAF/CProgressWidget.h \
	include/OAF/CElidedLabel.h

#
# C++ Sources list
#
SOURCES += \
	src/CLineEdit.cpp \
	src/CTabWidget.cpp \
	src/CUIManager.cpp \
	src/DockResizeHelper.cpp \
	src/ViewFindHelper.cpp \
	src/CSearchLineWidget.cpp \
	src/CWebView.cpp \
	src/CProgressWidget.cpp \
	src/CUIContainer.cpp \
	src/CElidedLabel.cpp

#
# Graphical User Interface forms
#
FORMS += \
	src/CSearchLineWidget.ui \
	src/CWebView.ui \
	src/CWebSearchWidget.ui

#
# Embeddable resources
#
RESOURCES += \
	src/resources/liboaf_gui.qrc
