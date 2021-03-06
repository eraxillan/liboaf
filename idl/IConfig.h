/**
 * @file
 * @brief Пакет интерфейсов подсистемы конфигурирования объектов
 * @author Sergey N. Yatskevich <syatskevich@gmail.com>
 * @copyright SpectrumSoft. All rights reserved. This file is part of liboaf,
 *            distributed under the GNU GPL v2 with a Linking Exception. For
 *            full terms see the included COPYING file.
 */
#ifndef __ICONFIG_H
#define __ICONFIG_H

#include <idl/IInterface.h>
#include <idl/IPropertyBag.h>

namespace OAF
{
	/**
	 * @brief Интерфейс конфигурирования
	 */
	struct IConfigurable : virtual public OAF::IInterface
	{
		/**
		 * @brief Установка конфигурации для объекта
		 *
		 * Объект должен держать ссылку на конфигурацию. Отключение объекта от
		 * конфигурации выполняется заданием для него NULL-указателя.
		 *
		 * Если для объекта была ранее задана конфигурация, то возвращается ссылка на неё.
		 */
		virtual OAF::URef<OAF::IPropertyBag> setConfiguration (OAF::IPropertyBag* _config) = 0;

		/**
		 * @brief Запрос конфигурации для объекта
		 */
		virtual OAF::URef<OAF::IPropertyBag> getConfiguration () = 0;

		/**
		 * @brief Показать диалог настройки конфигурации
		 */
		virtual void showConfigurationDialog () = 0;
	};
}

#endif /* __ICONFIG_H */
