HASHSRCDIR = $${GIT2SRCDIR}/hash
INCLUDEPATH+= $${HASHSRCDIR}

#
# Implementation of SHA1 key hash generation
#
#SHA1_USE_GENERIC {
#	HEADERS += $${HASHSRCDIR}/hash_generic.h
#	SOURCES += $${HASHSRCDIR}/hash_generic.c
#} else: SHA1_USE_SSL {
#	HEADERS += $${HASHSRCDIR}/hash_openssl.h
#} else: SHA1_USE_WIN32 {
#	HEADERS += $${HASHSRCDIR}/hash_win32.h
#	SOURCES += $${HASHSRCDIR}/hash_win32.c
#}

win32 {
	DEFINES += WIN32_SHA1
	HEADERS += $${HASHSRCDIR}/hash_win32.h
	SOURCES += $${HASHSRCDIR}/hash_win32.c
} else {
	HEADERS += $${HASHSRCDIR}/hash_generic.h
	SOURCES += $${HASHSRCDIR}/hash_generic.c
}
