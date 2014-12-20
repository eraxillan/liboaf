TARGET   = oaf-git2
TEMPLATE = lib

#
# Build configuration
#
CONFIG += qt thread warn_on

#
# Dynamic linking configuration for the library under Windows
#
win32:CONFIG  += dll
win32:DEFINES += OAFGIT2_LIBRARY

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
TOPSRCDIR = .

#
# The base library directories
#
GIT2SRCDIR         = $${TOPSRCDIR}/src
GIT2INCLUDEDIRMAIN = $${TOPSRCDIR}/include
GIT2DEPSDIR        = $${TOPSRCDIR}/deps

INCLUDEPATH += $${GIT2INCLUDEDIRMAIN}
INCLUDEPATH += $${GIT2SRCDIR}

#
# Determine current CPU architecture and build libgit2 for it
#
contains(QMAKE_HOST.arch, x86_64) {
	DEFINES += GIT_ARCH_64
} else {
	DEFINES += GIT_ARCH_32
}

#
# Under Windows library must use stdcall calling convention
# and the multithreaded C runtime library:
#
# /Gz - stdcall convention
# /GF - String pooling
# /MP - Parallel build
# /Zi - Create debugging information
# /Od - Disable optimization
# /D_DEBUG - #define _DEBUG
# /MTd - Statically link the multithreaded debug version of the CRT
# /MDd - Dynamically link the multithreaded debug version of the CRT
# /RTC1 - Run time checks
# /DNDEBUG - Disables asserts
# /MT - Statically link the multithreaded release version of the CRT
# /MD - Dynamically link the multithreaded release version of the CRT
# /O2 - Optimize for speed
# /Oy - Enable frame pointer omission (FPO) (otherwise CMake will automatically turn it off)
# /GL - Link time code generation (whole program optimization)
# /Gy - Function-level linking
#
win32 {
	contains(QMAKE_CC, cl) {
		#
		# Microsoft Visual C++
		#
#		QMAKE_CFLAGS_DEBUG += /Gz
		#
		# Debug
		#
		QMAKE_CFLAGS_DEBUG += /MDd /GF /MP /nologo /Zi /Od /D_DEBUG /RTC1
		QMAKE_CFLAGS_DEBUG -= /Zm1000
		#
		# Release
		#
		QMAKE_CFLAGS_RELEASE += /MD /GF /MP /nologo /DNDEBUG /O2 /Oy /GL /Gy
		QMAKE_CFLAGS_RELEASE -= /Zm1000

		#
		# Under Windows X86-64 we will compile the X86-64 library version
		#
		contains(QMAKE_HOST.arch, x86_64) {
			QMAKE_CFLAGS_DEBUG += /MACHINE:x64
			QMAKE_CFLAGS_RELEASE += /MACHINE:x64
		}

		#
		# /DYNAMICBASE - Address space load randomization (ASLR)
		# /NXCOMPAT - Data execution prevention (DEP)
		# /LARGEADDRESSAWARE - >2GB user address space on x86
		#
		QMAKE_LFLAGS += /DYNAMICBASE /NXCOMPAT /LARGEADDRESSAWARE

		#
		# /DEBUG - Create a PDB
		# /LTCG - Link time code generation (whole program optimization)
		# /OPT:REF /OPT:ICF - Fold out duplicate code at link step
		# /INCREMENTAL:NO - Required to use /LTCG
		# /DEBUGTYPE:cv,fixup - Additional data embedded in the PDB (requires /INCREMENTAL:NO, so not on for Debug)
		#
		QMAKE_LFLAGS_DEBUG += /DEBUG
		QMAKE_LFLAGS_RELEASE += /RELEASE /LTCG /OPT:REF /OPT:ICF /INCREMENTAL:NO

		#
		# Link with Windows Sockets libraries (optionally)
		#
#		LIBS += ws2_32
		#
		# Use Windows API for work with HTTP protocol
		#
		DEFINES += GIT_WINHTTP
		QMAKE_CXXFLAGS += /UUNICODE
		CONFIG += GIT_WINHTTP
		#
		# Specific flags for Windows API usage
		#
		DEFINES += -DWIN32 -D_WIN32_WINNT=0x0501

		#
		# Include header with standart integer types (gcc already have one)
		#
		HEADERS += include/git2/inttypes.h

		#
		# Use the POSIX regular expressions library
		#
		include ($${GIT2DEPSDIR}/regex/regex.pri)

		LIBS += Advapi32.lib

		include ($${GIT2SRCDIR}/win32/win32.pri)
	}
}
else: unix {
	QMAKE_CFLAGS_DEBUG += -D_GNU_SOURCE -Wall -Wstrict-prototypes
	QMAKE_CFLAGS_RELEASE += -D_GNU_SOURCE -Wall -Wstrict-prototypes

	include ($${GIT2SRCDIR}/unix/unix.pri)
} else {
	error ("Unsupported platform!")
}

#
# In other cases (Windows and Visual C++) we will use internal library
# to work with HTTP protocol
#
#
!GIT_WINHHTP {
	include ($${GIT2DEPSDIR}/http-parser/http-parser.pri)
}

#
# Enable the library debug output under debug build
#
CONFIG(debug,debug|release) {
	DEFINES += GIT_TRACE
}

#
# TODO: Select the appropriate SHA1 implementation depending on operating system and C++ compiler
# For a while we we will used internal one, because the implemetation differences are not so obvious
#
# NOTE: use CONFIG instead of DEFINES, because this variable is qmake-specific
# and will not be visible to the compiler
#IF (WIN32 AND NOT MINGW AND NOT SHA1_TYPE STREQUAL "builtin")
#	ADD_DEFINITIONS(-DWIN32_SHA1)
#	FILE(GLOB SRC_SHA1 src/hash/hash_win32.c)
#ELSEIF (OPENSSL_FOUND AND NOT SHA1_TYPE STREQUAL "builtin")
#	ADD_DEFINITIONS(-DOPENSSL_SHA1)
#ELSE()
#	FILE(GLOB SRC_SHA1 src/hash/hash_generic.c)
#ENDIF()
win32 {
	DEFINES += WIN32_SHA1
} else {
	CONFIG += SHA1_USE_GENERIC
}

#
# Link the required dependency: zlib, ZIP algorithm compression library
#
DEFINES += NO_VIZ
DEFINES += STDC
DEFINES += NO_GZIP
include ($${GIT2DEPSDIR}/zlib/zlib.pri)

#
# Link the optional dependency: libssh2, for the remote git repository access using SSH protocol
#
# TODO: store libssh2 inside of library like zlib in deps directory
#
#packagesExist (libssh2) {
#	DEFINES += GIT_SSH
#
#	INCLUDEPATH += /usr/include/libssh2.h \
#		/usr/include/libssh2_publickey.h \
#		/usr/include/libssh2_sftp.h
#
#	LIBS += -lssh2
#}

#
# Link the optional dependency: openssl, for the more secure SHA1-keys hash generation
# and secure access to remote git repository using HTTPS protocol
#
#packagesExist(openssl) {
#	DEFINES += GIT_SSL
# TODO: configure header path under Windows using the separate variable
#	INCLUDEPATH += openssl/err.h \
#		openssl/sha.h \
#		openssl/ssl.h \
#		openssl/x509v3.h
#
#	LIBS += -lssl -lcrypto
#}

#
# TODO: do we need this thread safety?
#
#DEFINES += GIT_THREADS

DEFINES += _FILE_OFFSET_BITS=64

#
# C++ Headers list
#
HEADERS += \
	include/git2.h \
	include/git2/attr.h \
	include/git2/blame.h \
	include/git2/blob.h \
	include/git2/branch.h \
	include/git2/buffer.h \
	include/git2/checkout.h \
	include/git2/clone.h \
	include/git2/commit.h \
	include/git2/common.h \
	include/git2/config.h \
	include/git2/cred_helpers.h \
	include/git2/diff.h \
	include/git2/errors.h \
	include/git2/filter.h \
	include/git2/graph.h \
	include/git2/ignore.h \
	include/git2/index.h \
	include/git2/indexer.h \
	include/git2/merge.h \
	include/git2/message.h \
	include/git2/net.h \
	include/git2/notes.h \
	include/git2/object.h \
	include/git2/odb.h \
	include/git2/odb_backend.h \
	include/git2/oid.h \
	include/git2/pack.h \
	include/git2/patch.h \
	include/git2/pathspec.h \
	include/git2/push.h \
	include/git2/refdb.h \
	include/git2/reflog.h \
	include/git2/refs.h \
	include/git2/refspec.h \
	include/git2/remote.h \
	include/git2/repository.h \
	include/git2/reset.h \
	include/git2/revert.h \
	include/git2/revparse.h \
	include/git2/revwalk.h \
	include/git2/signature.h \
	include/git2/stash.h \
	include/git2/status.h \
	include/git2/stdint.h \
	include/git2/strarray.h \
	include/git2/submodule.h \
	include/git2/tag.h \
	include/git2/threads.h \
	include/git2/trace.h \
	include/git2/transport.h \
	include/git2/tree.h \
	include/git2/types.h \
	include/git2/version.h \
	include/git2/pathspec.h

#
# Library internal headers for low-level wirk with commits, indeces and other git objects
#
HEADERS += \
	include/git2/sys/commit.h \
	include/git2/sys/config.h \
	include/git2/sys/filter.h \
	include/git2/sys/index.h \
	include/git2/sys/odb_backend.h \
	include/git2/sys/refdb_backend.h \
	include/git2/sys/reflog.h \
	include/git2/sys/refs.h \
	include/git2/sys/repository.h

HEADERS += \
	src/attr.h \
	src/attr_file.h \
	src/bitvec.h \
	src/blame.h \
	src/blame_git.h \
	src/attrcache.h \
	src/blob.h \
	src/branch.h \
	src/branch.h \
	src/branch.h \
	src/buf_text.h \
	src/buffer.h \
	src/cache.h \
	src/cc-compat.h \
	src/checkout.h \
	src/commit.h \
	src/commit_list.h \
	src/common.h \
	src/compress.h \
	src/config.h \
	src/config_file.h \
	src/delta-apply.h \
	src/delta.h \
	src/diff.h \
	src/fetch.h \
	src/fetchhead.h \
	src/filebuf.h \
	src/fileops.h \
	src/filter.h \
	src/fnmatch.h \
	src/global.h \
	src/hash.h \
	src/hashsig.h \
	src/ignore.h \
	src/index.h \
	src/iterator.h \
	src/khash.h \
	src/map.h \
	src/merge.h \
	src/merge_file.h \
	src/message.h \
	src/mwindow.h \
	src/netops.h \
	src/notes.h \
	src/object.h \
	src/odb.h \
	src/offmap.h \
	src/oid.h \
	src/oidmap.h \
	src/pack-objects.h \
	src/pack.h \
	src/path.h \
	src/pathspec.h \
	src/pool.h \
	src/posix.h \
	src/pqueue.h \
	src/push.h \
	src/refdb.h \
	src/refdb_fs.h \
	src/reflog.h \
	src/refs.h \
	src/refspec.h \
	src/remote.h \
	src/repo_template.h \
	src/repository.h \
	src/revwalk.h \
	src/sha1_lookup.h \
	src/signature.h \
	src/sortedcache.h \
	src/strmap.h \
	src/submodule.h \
	src/tag.h \
	src/thread-utils.h \
	src/trace.h \
	src/tree-cache.h \
	src/tree.h \
	src/util.h \
	src/vector.h \
	src/array.h \
	src/bitvec.h \
	src/diff_driver.h \
	src/diff_file.h \
	src/diff_patch.h \
	src/diff_xdiff.h \
	src/status.h

#
# C++ Sources list
#
SOURCES += \
	src/attr.c \
	src/attr_file.c \
	src/blame.c \
	src/blame_git.c \
	src/blob.c \
	src/branch.c \
	src/buf_text.c \
	src/buffer.c \
	src/cache.c \
	src/checkout.c \
	src/clone.c \
	src/commit.c \
	src/commit_list.c \
	src/compress.c \
	src/config.c \
	src/config_cache.c \
	src/config_file.c \
	src/crlf.c \
	src/date.c \
	src/delta-apply.c \
	src/delta.c \
	src/diff.c \
	src/diff_tform.c \
	src/errors.c \
	src/fetch.c \
	src/fetchhead.c \
	src/filebuf.c \
	src/fileops.c \
	src/filter.c \
	src/fnmatch.c \
	src/global.c \
	src/graph.c \
	src/hash.c \
	src/hashsig.c \
	src/ident.c \
	src/ignore.c \
	src/index.c \
	src/indexer.c \
	src/iterator.c \
	src/merge.c \
	src/merge_file.c \
	src/message.c \
	src/mwindow.c \
	src/netops.c \
	src/notes.c \
	src/object.c \
	src/object_api.c \
	src/odb.c \
	src/odb_loose.c \
	src/odb_pack.c \
	src/oid.c \
	src/pack-objects.c \
	src/pack.c \
	src/path.c \
	src/pathspec.c \
	src/pool.c \
	src/posix.c \
	src/pqueue.c \
	src/push.c \
	src/refdb.c \
	src/refdb_fs.c \
	src/reflog.c \
	src/refs.c \
	src/refspec.c \
	src/remote.c \
	src/repository.c \
	src/reset.c \
	src/revert.c \
	src/revparse.c \
	src/revwalk.c \
	src/sha1_lookup.c \
	src/signature.c \
	src/sortedcache.c \
	src/stash.c \
	src/status.c \
	src/strmap.c \
	src/submodule.c \
	src/tag.c \
	src/thread-utils.c \
	src/trace.c \
	src/transport.c \
	src/tree-cache.c \
	src/tree.c \
	src/tsort.c \
	src/util.c \
	src/vector.c \
	src/diff_driver.c \
	src/diff_file.c \
	src/diff_patch.c \
	src/diff_print.c \
	src/diff_xdiff.c \
	src/intl/libgit2_intl.cpp

#
# Include subprojects with various implementations of hash generation, network access, diff search in the text
#
include(src/xdiff/xdiff.pri)
include(src/transports/transports.pri)
include(src/hash/hash.pri)
