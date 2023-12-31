
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Бурдо Э.В. Добавлены новые элементы на форму
	// Бурдо Э.В. Начало доработки  
	
	ПолеКонтактноеЛицо = Элементы.Вставить("БЭ_КонтактноеЛицо",Тип("ПолеФормы"),Элементы.ГруппаШапкаПраво);
	ПолеКонтактноеЛицо.Вид = ВидПоляФормы.ПолеВвода;
	ПолеКонтактноеЛицо.ПутьКДанным = "Объект.БЭ_КонтактноеЛицо";
	
	Связь = Новый СвязьПараметраВыбора("Отбор.Владелец","Объект.Контрагент");
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Связь);
	НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.БЭ_КонтактноеЛицо.СвязиПараметровВыбора = НовыеСвязи;
	
	НоваяГруппа = ЭтотОбъект.Элементы.Добавить("ГруппаОбычная", Тип("ГруппаФормы"),Элементы.ГруппаШапкаЛево);
	НоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НоваяГруппа.ОтображатьЗаголовок = ЛОЖЬ; 
	НоваяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	
	ПолеСкидка = Элементы.Вставить("БЭ_Скидка", Тип("ПолеФормы"),НоваяГруппа);
	ПолеСкидка.Вид = ВидПоляФормы.ПолеВвода;
	ПолеСкидка.ПутьКДанным = "Объект.БЭ_Скидка";
	
    Команда = ЭтотОбъект.Команды.Добавить("ПересчитатьТаблицу");
    Команда.Заголовок = "Пересчитать таблицу";
	Команда.Действие = "ПересчитатьТаблицуНажатие";
    	
	Кнопка = ЭтотОбъект.Элементы.Добавить("КнопкаПересчитатьТаблицу", Тип("КнопкаФормы"),НоваяГруппа);
	Кнопка.Заголовок = "Пересчитать таблицу";
	Кнопка.Отображение = ОтображениеКнопки.КартинкаИТекст;
	Кнопка.Картинка = БиблиотекаКартинок.Обновить;
	Кнопка.ИмяКоманды = "ПересчитатьТаблицу"; 
	
	Элементы.БЭ_Скидка.УстановитьДействие("ПриИзменении","БЭ_СкидкаПриИзменении");
	// Бурдо Э.В. КонецДоработки
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСкидкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиСкидкаПриИзменении(Элемент)
		
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура УслугиПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСуммуСтроки(ТекущиеДанные)

	//Бурдо Э.В. закоментирован стандартный код
	//КоэффициентСкидки = 1 - ТекущиеДанные.Скидка / 100;
	//ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество * КоэффициентСкидки;
	//Конец стандартного кода
	//Начало доработки
	КоэффициентСкидки = ТекущиеДанные.Скидка + Объект.БЭ_Скидка;
	Если КоэффициентСкидки < 100 И КоэффициентСкидки > 0 Тогда
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество * ((100 - КоэффициентСкидки)/100);
	ИначеЕсли КоэффициентСкидки > 100 Тогда
		ТекущиеДанные.Сумма = 0;
	Иначе
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;
	КонецЕсли;
	//КонецДоработки
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//Бурдо Э.В. Начало доработки
&НаКлиенте
Асинх Процедура БЭ_СкидкаПриИзменении(Элемент)
	Ответ = Ждать ВопросАсинх("Изменен процент скидка. Пересчитать данные в таблице?",РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ТабТовары = Объект.Товары;
		Для каждого Строка из ТабТовары Цикл 
			РассчитатьСуммуСтроки(Строка); 
		КонецЦикла;
		ТабУслуги = Объект.Услуги;
		Для каждого Строка из ТабУслуги Цикл 
			РассчитатьСуммуСтроки(Строка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры  
//Конец доработки

//Бурдо Э.В. добавление процедуры 
//Начало доработки
//@skip-check module-unused-method
//&НаКлиенте
//Процедура ПересчитатьТаблицуНажатие(Команда)
//	ТабТовары = Объект.Товары;
//	Для каждого Строка из ТабТовары Цикл 
//		РассчитатьСуммуСтроки(Строка); 
//	КонецЦикла;
//	ТабУслуги = Объект.Услуги;
//	Для каждого Строка из ТабУслуги Цикл 
//		РассчитатьСуммуСтроки(Строка);
//	КонецЦикла;
//КонецПроцедуры

//Конец доработки
#КонецОбласти

#КонецОбласти


