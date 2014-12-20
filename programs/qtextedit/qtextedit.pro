TARGET   = qtextedit
TEMPLATE = app

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
# Debug Windows output
#
win32:CONFIG(debug):CONFIG += console

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
# OAF-GIT2
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-git2/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-git2/$${buildmode} -loaf-git2

#
# OAF-STD
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-std/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-std/$${buildmode} -loaf-std-qt4

#
# OAF-GUI
#
INCLUDEPATH += $${TOPSRCDIR}/libs/liboaf-gui/include
LIBS        += -L$${TOPSRCDIR}/libs/liboaf-gui/$${buildmode} -loaf-gui-qt4

#
# C++ Headers list
#
HEADERS += \
	src/CMainWindow.h

#
# C++ Sources list
#
SOURCES += \
	src/CMainWindow.cpp \
	src/main.cpp
