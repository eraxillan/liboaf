TEMPLATE = subdirs
CONFIG  += ordered
SUBDIRS  = libs plugins programs

#
# Component Interfaces
#
HEADERS += \
	idl/IConfig.h \
	idl/INotifySource.h \
	idl/IGenericFactory.h \
	idl/IInterface.h \
	idl/IIODevice.h \
	idl/IMoniker.h \
	idl/IObjectSource.h \
	idl/IPropertyBag.h \
	idl/IQuery.h \
	idl/ISqlDatabase.h \
	idl/ITextDocument.h \
	idl/ITextSignature.h \
	idl/ITXTPersist.h \
	idl/ITreeNode.h \
	idl/IUIComponent.h \
	idl/IXMLPersist.h \
	idl/IUnknown.h \
	idl/IDifference.h \
	idl/ISearch.h \
	idl/IExchange.h \
	idl/IOperation.h

#
# Translations to other languages (currently Russian only)
#
TRANSLATIONS += \
	translate/liboaf_ru.ts

TRANSLATIONS_FILES += \
	translate/liboaf_ru.qm

#
# Shared data installation path configuration
#
win32 {
	isEmpty(DATA_INSTALL_PATH):DATA_INSTALL_PATH = /data
}
else {
	isEmpty(DATA_INSTALL_PATH):DATA_INSTALL_PATH = /usr/share/oaf-qt4
}

#
# Shared data installation target configuration
#
data.files = share/*
data.path  = $${DATA_INSTALL_PATH}

#
# Translations installation target configuration
#
translations.files = $${TRANSLATIONS_FILES}
translations.path  = $${DATA_INSTALL_PATH}/translate

#
# Installation targets configuration
#
INSTALLS += data translations
