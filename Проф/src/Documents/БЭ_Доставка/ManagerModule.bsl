Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Анкета о доставке
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АнкетаОДоставке";
	КомандаПечати.Представление = НСтр("ru = 'Анкета о доставке'");
	КомандаПечати.Порядок = 5;
	
	// Транспортная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ТранспортнаяНакладная";
	КомандаПечати.Представление = НСтр("ru = 'Транспортная накладная'");
	КомандаПечати.Порядок = 10;
		
	// Комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АнкетаОДоставке,ТранспортнаяНакладная";
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов'");
	КомандаПечати.Порядок = 75;
	
	// Договор
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Договор";
	КомандаПечати.Представление = НСтр("ru = 'Договор'");
	КомандаПечати.Порядок = 75;
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АнкетаОДоставке");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАнкеты(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Анкета о доставке'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.БЭ_Доставка.АнкетаОДоставке";
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ТранспортнаяНакладная");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьНакладной(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Транспортная накладная'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.БЭ_Доставка.ТранспортнаяНакладная";
	КонецЕсли;

	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Договор");
	Если ПечатнаяФорма <> Неопределено Тогда
		ОфисныеДокументы = НапечататьДоговорDOCX(МассивОбъектов);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Договор (MS Word)'");
		ПечатнаяФорма.ОфисныеДокументы = ОфисныеДокументы;
	КонецЕсли;	
КонецПроцедуры

Функция ПечатьАнкеты(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Счет";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.БЭ_Доставка.АкетаОДоставке");
	
	РезультатПакета = ПолучитьДанныеДокументов(МассивОбъектов);
	ДанныеДокументов = РезультатПакета[0].Выбрать();
	
	ПервыйДокумент = Истина;
	ОбластьАнкеты = Макет.ПолучитьОбласть("Анкета");

	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ОбластьАнкеты.Параметры.Номер = СтрЗаменить(ДанныеДокументов.Номер,"0","");
		ОбластьАнкеты.Параметры.Дата = Формат(ДанныеДокументов.Дата,  "ДФ=dd.MM.yyyy");	
		
		ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(Строка(ДанныеДокументов.Ссылка.УникальныйИдентификатор()), 1, 120);
		Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
			ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
			|Технические подробности см. в журнале регистрации.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Иначе
			КартинкаQRКода = Новый Картинка(ДанныеQRКода);
			ОбластьАнкеты.Рисунки.ДанныеАнкеты.Картинка = КартинкаQRКода;
		КонецЕсли;		
		
		ТабличныйДокумент.Вывести(ОбластьАнкеты);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		    НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
				
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьНакладной(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Счет";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.БЭ_Доставка.ТранспортнаяНакладная");
	
	РезультатПакета = ПолучитьДанныеДокументов(МассивОбъектов);
	ДанныеДокументов = РезультатПакета[0].Выбрать();
	
	ПервыйДокумент = Истина;
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");

	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ОбластьШапка.Параметры.Номер = СтрЗаменить(ДанныеДокументов.Номер,"0","");
		ОбластьШапка.Параметры.Дата = Формат(ДанныеДокументов.Дата,  "ДФ=dd.MM.yyyy");
		ОбластьШапка.Параметры.Отправитель = ДанныеДокументов.Организация;
		ОбластьШапка.Параметры.Получатель = ДанныеДокументов.Контрагент;
		
		
		ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(Строка(ДанныеДокументов.Ссылка.УникальныйИдентификатор()), 1, 120);
		Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
			ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
			|Технические подробности см. в журнале регистрации.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Иначе
			КартинкаQRКода = Новый Картинка(ДанныеQRКода);
			ОбластьШапка.Рисунки.СведенияОНакладной.Картинка = КартинкаQRКода;
		КонецЕсли;		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		ДанныеТоваров = РезультатПакета[1].Выбрать();
		НомерСтроки = 1;
		Пока ДанныеТоваров.Следующий() Цикл
			Если ДанныеТоваров.Ссылка = ДанныеДокументов.Ссылка Тогда
				ОбластьСтрока.Параметры.Номер = НомерСтроки;
				ОбластьСтрока.Параметры.Товар = ДанныеТоваров.Номенклатура;
				ОбластьСтрока.Параметры.Количество = ДанныеТоваров.Количество;
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				НомерСтроки = НомерСтроки + 1; 
			КонецЕсли;
		КонецЦикла;	

		
		ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
		ТабличныйДокумент.Вывести(ОбластьПодписи);

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		    НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);					
	КонецЦикла;	
	
	
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция НапечататьДоговорDOCX(МассивОбъектов)
	// Создаём пустое соответствие для размещения печатных форм OpenXМL — результат функции
	ОфисныеДокументы = Новый Соответствие;
	
	// Готовим макет для формирования печатной формы OpenXML
	МакетДокумента = УправлениеПечатью.МакетПечатнойФормы("Документ.БЭ_Доставка.ПФ_DOC_Договор");
	Макет = УправлениеПечатью.ИнициализироватьМакетОфисногоДокумента(МакетДокумента,
	Неопределено);  
	
	// Создаём структуру областей формируемой печатной формы OpenXМL
	ОписаниеОбластей = Новый Структура;
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Шапка", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ПредметДоговора", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ПраваИОбязанности", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "СуммаДоговора", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Ответственность", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Порядок", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "АдресаИПодписи", "Общая");
	
	// Получаем данные для печати из базы данных
	// Функцию ДанныеДляПечатиДоговора необходимо разработать самостоятельно
	ДанныеДляПечати = ДанныеДляПечатиДоговора(МассивОбъектов);
	
	Для Каждого ДанныеДокумента Из ДанныеДляПечати Цикл 
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ДанныеДокумента);
		// Готовим печатную форму в формате офисного документа
		ПечатнаяФорма = УправлениеПечатью.ИнициализироватьПечатнуюФорму(Неопределено, Неопределено, Макет);
		
		ОбластьШапка = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["Шапка"]);
		ОбластьПредметДоговора = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["ПредметДоговора"]);
		ОбластьПраваИОбязанности = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["ПраваИОбязанности"]);
		ОбластьСуммаДоговора = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["СуммаДоговора"]);
		ОбластьОтветственность = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["Ответственность"]);
		ОбластьПорядок = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["Порядок"]);
		ОбластьАдресаИПодписи = УправлениеПечатью.ОбластьМакета(Макет, ОписаниеОбластей["АдресаИПодписи"]);
	
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьШапка, ДанныеПечати); 
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьПредметДоговора, ДанныеПечати);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьПраваИОбязанности, ДанныеПечати);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьСуммаДоговора, ДанныеПечати);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьОтветственность, ДанныеПечати);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьПорядок, ДанныеПечати); 
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьАдресаИПодписи, ДанныеПечати);

		
		АдресХранилищаПечатнойФормы = УправлениеПечатью.СформироватьДокумент(ПечатнаяФорма);
		ОфисныеДокументы.Вставить(АдресХранилищаПечатнойФормы, Строка(ДанныеПечати.Ссылка));
		УправлениеПечатью.ОчиститьСсылки(ПечатнаяФорма);
		
	КонецЦикла;        
	
	УправлениеПечатью.ОчиститьСсылки(Макет);
	
	Возврат ОфисныеДокументы;
    
КонецФункции  

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БЭ_Доставка.Номер КАК Номер,
	               |	БЭ_Доставка.Дата КАК Дата,
	               |	БЭ_Доставка.Организация КАК Организация,
	               |	БЭ_Доставка.Контрагент КАК Контрагент,
	               |	БЭ_Доставка.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.БЭ_Доставка КАК БЭ_Доставка
	               |ГДЕ
	               |	БЭ_Доставка.Ссылка В(&Ссылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	БЭ_ДоставкаТовары.НомерСтроки КАК НомерСтроки,
	               |	БЭ_ДоставкаТовары.Номенклатура КАК Номенклатура,
	               |	БЭ_ДоставкаТовары.Количество КАК Количество,
	               |	БЭ_ДоставкаТовары.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.БЭ_Доставка.Товары КАК БЭ_ДоставкаТовары
	               |ГДЕ
	               |	БЭ_ДоставкаТовары.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);

	РезультатПакета = Запрос.ВыполнитьПакет();
	Возврат РезультатПакета;	
КонецФункции

Функция ДанныеДляПечатиДоговора(МассивОбъектов)
 	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БЭ_Доставка.Номер КАК Номер,
	               |	БЭ_Доставка.Дата КАК Дата,
	               |	БЭ_Доставка.Организация КАК Организация,
	               |	БЭ_Доставка.Контрагент КАК Контрагент,
	               |	БЭ_Доставка.Ссылка КАК Ссылка,
	               |	БЭ_Доставка.КонтактноеЛицо.Владелец КАК КонтактноеЛицоВладелец,
	               |	БЭ_Доставка.КонтактноеЛицо.ДействуетНаОсновании КАК КонтактноеЛицоДействуетНаОсновании
	               |ИЗ
	               |	Документ.БЭ_Доставка КАК БЭ_Доставка
	               |ГДЕ
	               |	БЭ_Доставка.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
КонецФункции