Перем ВидПоиска Экспорт;

Перем Данные;
Перем ПодготовленныеДанные;
Перем Транслит;
Перем КодыАнгл;
Перем КодыРус;
Перем ВсеКоды;
Перем СоответствияКодов;
Перем ФонетическаяГруппаРус;
Перем ФонетическаяГруппаАнг;

Процедура ПриСозданииОбъекта()
	
	ВидПоиска = 1;//ВидыПоиска.ПоискЗначения;

	ИнициализироватьСправочники();

КонецПроцедуры

Процедура УстановитьДанные(ДанныеДляПоиска) Экспорт
	Данные = ДанныеДляПоиска;
	ПодготовитьДанные();
КонецПроцедуры

Процедура ПодготовитьДанные()
	ПодготовленныеДанные = Новый Массив();
	Для каждого Фраза Из Данные Цикл
		Набор = Новый ЯзыковойНабор();
		Набор.Русский.ОригинальныйТекст = Фраза;
		Если СтрДлина(Фраза) > 0 Тогда
			Для Каждого ТекстСлова из СтрРазделить(Фраза, " ") Цикл
				Слово = Новый Слово();
				Слово.Текст = НРег(ТекстСлова);
				Слово.СписокКодов = ПолучитьКоды(Слово.Текст, ВсеКоды);
				Набор.Русский.Слова.Добавить(Слово);
			КонецЦикла;
		КонецЕсли;
		ПодготовленныеДанные.Добавить(Набор);
	КонецЦикла;
КонецПроцедуры

Функция ВыполнитьПоиск(СтрокаПоиска) Экспорт
	Анализ = Новый ОбъектАнализа();	
	Трасляция = Новый ОбъектАнализа();
	Если СтрДлина(СтрокаПоиска) > 0 Тогда
		Для Каждого ТекстСлова из СтрРазделить(СтрокаПоиска, " ") Цикл
			Слово = Новый Слово();
			Слово.Текст = НРег(ТекстСлова);
			Слово.СписокКодов = ПолучитьКоды(Слово.Текст, ВсеКоды);
			Анализ.Слова.Добавить(Слово);

			ТранслитСлово = Новый Слово();
			ТранслитСлово.Текст = Транслитировать(НРег(ТекстСлова), Транслит);
			ТранслитСлово.СписокКодов = ПолучитьКоды(ТранслитСлово.Текст, ВсеКоды);
			Трасляция.Слова.Добавить(ТранслитСлово);
		КонецЦикла;
	КонецЕсли;

	Результат = Новый Массив;
	Для Каждого Набор из ПодготовленныеДанные Цикл
		ТипЯзыка = 1;
		Вес = ОтранжироватьФразу(Набор.Русский, Анализ, Ложь);
		времВес = ОтранжироватьФразу(Набор.Английский, Анализ, Ложь);
		Если Вес > времВес Тогда
			Вес = времВес;
			ТипЯзыка = 3;
		КонецЕсли;

		времВес = ОтранжироватьФразу(Набор.Русский, Трасляция, Истина);
		Если Вес > времВес Тогда
			Вес = времВес;
			ТипЯзыка = 2;
		КонецЕсли;

		времВес = ОтранжироватьФразу(Набор.Английский, Трасляция, Истина);
		Если Вес > времВес Тогда
			Вес = времВес;
			ТипЯзыка = 3;
		КонецЕсли;

		Результат.Добавить(Новый Структура("Русское, Английское, Вес, ТипЯзыка", 
											Набор.Русский.ОригинальныйТекст,
											Набор.Английский.ОригинальныйТекст,
											Вес,
											ТипЯзыка
		));

	КонецЦикла;

	Возврат Результат;
		
КонецФункции

Функция Транслитировать(Знач ТекстТрансляции, Словарь)
	Результат = ТекстТрансляции;
	Для каждого КиЗ Из Словарь Цикл
		Результат = СтрЗаменить(Результат, КиЗ.Ключ, КиЗ.Значение);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ПолучитьКоды(СтрокаСлова, ДопустимыеКоды)
	Результат = Новый Массив();
	Для Сч = 1 по СтрДлина(СтрокаСлова) Цикл
		ТекСимвол = Сред(СтрокаСлова, Сч, 1);
		ИскомыйКод = ДопустимыеКоды.Получить(ТекСимвол);
		Если не ИскомыйКод = Неопределено Тогда
			Результат.Добавить(ИскомыйКод);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ОтранжироватьФразу(Источник, Анализ, Трансляция)
	Если Источник.Слова.Количество() = 0 Тогда
		Если Анализ.Слова.Количество() = 0 Тогда
			Возврат 0;
		КонецЕсли;

		Результат = 0;
		Для Каждого Слово из Анализ.Слова Цикл
			Результат = Результат + СтрДлина(Слово.Текст) * 2 * 100;
			Возврат Результат;
		КонецЦикла;
	КонецЕсли;

	Если Анализ.Слова.Количество() = 0 Тогда
		Результат = 0;
		Для Каждого Слово из Источник.Слова Цикл
			Результат = Результат + СтрДлина(Слово.Текст) * 2 * 100;
			Возврат Результат;
		КонецЦикла;
	КонецЕсли;

	Результат = 0;

	Для СчАнализ = 0 по Анализ.Слова.Количество() - 1 Цикл
		МинВесСлова = 999999999999;
		МинИндекс = 0;
		///////////
		Для СчИсточник = 0 по Источник.Слова.Количество() - 1 Цикл
			ТекВесСлова = ОтранжироватьСлово(Источник.Слова[СчИсточник], Анализ.Слова[СчАнализ], Трансляция);

			Если ТекВесСлова < МинВесСлова Тогда
				МинВесСлова = ТекВесСлова;
				МинИндекс = СчИсточник;
			КонецЕсли;

		КонецЦикла;
		Результат = Результат + МинВесСлова * 100 + ( абс(СчАнализ - МинИндекс) / 10.0);
	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция абс(Число)

	Возврат ?(Число < 0 , Число * -1, Число);
	
КонецФункции

Функция ОтранжироватьСлово(СловоИсточник, СловоПоиск, Трансляция)
	МинРастояние = 999999999999;
	ОбрезанноеСлово = Новый Слово();
	Длина = МИН(СтрДлина(СловоИсточник.Текст), СтрДлина(СловоПоиск.Текст) + 1);
	
	Для Сч = 0 по СтрДлина(СловоИсточник.Текст) - Длина Цикл
		ОбрезанноеСлово.Текст = Сред(СловоИсточник.Текст, Сч, Длина);
		ОбрезанноеСлово.СписокКодов = ПолучитьКоды(ОбрезанноеСлово.Текст, ВсеКоды);
		МинРастояние = МИН(МинРастояние,
						   Растояние(ОбрезанноеСлово, СловоПоиск, СтрДлина(СловоИсточник.Текст) = СтрДлина(ОбрезанноеСлово.Текст), Трансляция) + (Сч * 2 / 10.0))
	КонецЦикла;
	Возврат МинРастояние;
КонецФункции

Функция ВесРастоянияСимволов(СловоИсточник, ПозицияВИсточнике, СловоПоиск, ПозицияВПоиске, Трансляция) Экспорт
	Если СимволСтроки(СловоИсточник.Текст, ПозицияВИсточнике) = СимволСтроки(СловоПоиск.Текст, ПозицияВПоиске) Тогда
		Возврат 0;
	КонецЕсли;

	Если Трансляция = Истина Тогда
		Возврат 2;
	КонецЕсли;

	Если не СловоИсточник.СписокКодов[ПозицияВИсточнике] = 0 И
		СловоИсточник.СписокКодов[ПозицияВИсточнике] = СловоПоиск.СписокКодов[ПозицияВПоиске] Тогда
		Возврат 0;
	КонецЕсли;
	
	Результат = 0; 

	КодКлавиши = СловоИсточник.СписокКодов[ПозицияВИсточнике];
	СоседниеКлавиши = СоответствияКодов.Получить(КодКлавиши);
	Если СоседниеКлавиши = Неопределено Тогда
		Результат = 2;
	Иначе
		Результат = ?(СоседниеКлавиши.Найти(СловоПоиск.СписокКодов[ПозицияВПоиске]) = Неопределено, 2,1);
	КонецЕсли;

	ФонетическиеГруппы = ФонетическаяГруппаРус.Получить(СимволСтроки(СловоПоиск.Текст, ПозицияВПоиске));
	Если не ФонетическиеГруппы = Неопределено Тогда
		Результат = МИН(Результат, ?(
			ФонетическиеГруппы.Найти(СимволСтроки(СловоИсточник,ПозицияВИсточнике)) = Неопределено, 
			2,
			1
		));
	КонецЕсли;

	ФонетическиеГруппы = ФонетическаяГруппаАнг.Получить(СимволСтроки(СловоПоиск.Текст, ПозицияВПоиске));
	Если не ФонетическиеГруппы = Неопределено Тогда
		Результат = МИН(Результат, ?(
			ФонетическиеГруппы.Найти(СимволСтроки(СловоИсточник,ПозицияВИсточнике)) = Неопределено, 
			2,
			1
		));
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция Растояние(СловоИсточник, СловоПоиск, СловоЦеликом, Трансляция) Экспорт

	Если ПустаяСтрока(СловоИсточник.Текст) Тогда
		Если ПустаяСтрока(СловоПоиск.Текст) Тогда
			Возврат 0;
		КонецЕсли;
		Возврат СтрДлина(СловоПоиск.Текст) * 2; 
	КонецЕсли;

	Если ПустаяСтрока(СловоПоиск.Текст) Тогда
		Возврат СтрДлина(СловоИсточник.Текст) * 2;
	КонецЕсли;

	ДлинаИсточника = СтрДлина(СловоИсточник.Текст);
	ДлинаПоиска = СтрДлина(СловоПоиск.Текст);

	ТаблицаРасстояний = Новый Матрица(3, ДлинаПоиска+1);

	Для Сч = 1 по ДлинаПоиска Цикл
		ТаблицаРасстояний.Значение(0, Сч, Сч * 2);
	КонецЦикла;

	ТекущаяСтрока = 0;
	
	Для СчИсточника = 1 по ДлинаИсточника Цикл
		ТекущаяСтрока = СчИсточника % 3;
		ПредыдущаяСтрока = (СчИсточника - 1) % 3;
		ТаблицаРасстояний.Значение(ТекущаяСтрока, 0, СчИсточника * 2);
		Для СчПоиска = 1 По ДлинаПоиска Цикл
			РасчетноеРастояние = МИН(
				МИН(ТаблицаРасстояний.Значение(ПредыдущаяСтрока, СчПоиска)+?(Не СловоЦеликом = Истина и СчИсточника = ДлинаИсточника, 1,2),
					ТаблицаРасстояний.Значение(ТекущаяСтрока, СчПоиска - 1)+?(Не СловоЦеликом = Истина и СчИсточника = ДлинаИсточника, 1,2)),			
					ТаблицаРасстояний.Значение(ПредыдущаяСтрока, СчПоиска - 1) + ВесРастоянияСимволов(СловоИсточник, СчИсточника-1, СловоПоиск, СчПоиска - 1, Трансляция) 
			);
			ТаблицаРасстояний.Значение(ТекущаяСтрока, СчПоиска, РасчетноеРастояние);
		КонецЦикла;

	КонецЦикла;

	Возврат ТаблицаРасстояний.Значение(ТекущаяСтрока, ДлинаПоиска);
	
КонецФункции

Функция Старое_Растояние(Источник, Приемник) Экспорт

	Если ПустаяСтрока(Источник) Тогда
		Если ПустаяСтрока(Приемник) Тогда
			Возврат 0;
		КонецЕсли;
		Возврат СтрДлина(Приемник); 
	КонецЕсли;

	ДлинаПриемника = СтрДлина(Приемник);
	ДлинаИсточника = СтрДлина(Источник);

	ТаблицаРасстояний = Новый Матрица(2, ДлинаПриемника+1);

	Для Сч = 1 по ДлинаПриемника Цикл
		ТаблицаРасстояний.Значение(0, Сч, Сч * 2);
	КонецЦикла;

	ТекущаяСтрока = 0;
	
	Для СчИсточника = 1 по ДлинаИсточника Цикл
		ТекущаяСтрока = ПобитовоеИ(СчИсточника, 1);
		ТаблицаРасстояний.Значение(ТекущаяСтрока, 0, СчИсточника * 2);
		ПредыдущаяСтрока = ПобитовоеИсключительноеИли(ТекущаяСтрока, 1);
		Для СчПриемника = 1 По ДлинаПриемника Цикл
			Вес = ?(СимволСтроки(Приемник , СчПриемника) = СимволСтроки(Источник, СчИсточника), 0, 1);	
			
			РасчетноеРастояние = МИН(
				МИН(
					ТаблицаРасстояний.Значение(ПредыдущаяСтрока, СчПриемника) + 2,
					ТаблицаРасстояний.Значение(ТекущаяСтрока, СчПриемника - 1) + 2
					),			
				ТаблицаРасстояний.Значение(ПредыдущаяСтрока, СчПриемника - 1) + Вес
			);
			ТаблицаРасстояний.Значение(ТекущаяСтрока, СчПриемника, РасчетноеРастояние);
		КонецЦикла;

	КонецЦикла;

	Возврат ТаблицаРасстояний.Значение(ТекущаяСтрока, ДлинаПриемника);
	
КонецФункции

Функция СимволСтроки(Строка, Номер) Экспорт
	Возврат Сред(Строка, Номер, 1);
КонецФункции

Процедура ИнициализироватьСправочники()
	Транслит = Новый Соответствие();
	Транслит.Вставить( "а", "a"   );
	Транслит.Вставить( "б", "b"   );
	Транслит.Вставить( "в", "v"   );
	Транслит.Вставить( "г", "g"   );
	Транслит.Вставить( "д", "d"   );
	Транслит.Вставить( "е", "e"   );
	Транслит.Вставить( "ё", "yo"  );
	Транслит.Вставить( "ж", "zh"  );
	Транслит.Вставить( "з", "z"   );
	Транслит.Вставить( "и", "i"   );
	Транслит.Вставить( "й", "i"   );
	Транслит.Вставить( "к", "k"   );
	Транслит.Вставить( "л", "l"   );
	Транслит.Вставить( "м", "m"   );
	Транслит.Вставить( "н", "n"   );
	Транслит.Вставить( "о", "o"   );
	Транслит.Вставить( "п", "p"   );
	Транслит.Вставить( "р", "r"   );
	Транслит.Вставить( "с", "s"   );
	Транслит.Вставить( "т", "t"   );
	Транслит.Вставить( "у", "u"   );
	Транслит.Вставить( "ф", "f"   );
	Транслит.Вставить( "х", "x"   );
	Транслит.Вставить( "ц", "c"   );
	Транслит.Вставить( "ч", "ch"  );
	Транслит.Вставить( "ш", "sh"  );
	Транслит.Вставить( "щ", "shh" );
	Транслит.Вставить( "ъ", ""    );
	Транслит.Вставить( "ы", "y"   );
	Транслит.Вставить( "ь", ""    );
	Транслит.Вставить( "э", "e"   );
	Транслит.Вставить( "ю", "yu"  );
	Транслит.Вставить( "я", "ya"  );

	КодыАнгл = Новый Соответствие();
	КодыАнгл.Вставить( "`", 192  );
	КодыАнгл.Вставить( "1", 49   );
	КодыАнгл.Вставить( "2", 50   );
	КодыАнгл.Вставить( "3", 51   );
	КодыАнгл.Вставить( "4", 52   );
	КодыАнгл.Вставить( "5", 53   );
	КодыАнгл.Вставить( "6", 54   );
	КодыАнгл.Вставить( "7", 55   );
	КодыАнгл.Вставить( "8", 56   );
	КодыАнгл.Вставить( "9", 57   );
	КодыАнгл.Вставить( "0", 48   );
	КодыАнгл.Вставить( "-", 189  );
	КодыАнгл.Вставить( "=", 187  );
	КодыАнгл.Вставить( "q", 81   );
	КодыАнгл.Вставить( "w", 87   );
	КодыАнгл.Вставить( "e", 69   );
	КодыАнгл.Вставить( "r", 82   );
	КодыАнгл.Вставить( "t", 84   );
	КодыАнгл.Вставить( "y", 89   );
	КодыАнгл.Вставить( "u", 85   );
	КодыАнгл.Вставить( "i", 73   );
	КодыАнгл.Вставить( "o", 79   );
	КодыАнгл.Вставить( "p", 80   );
	КодыАнгл.Вставить( "[", 219  );
	КодыАнгл.Вставить( "]", 221  );
	КодыАнгл.Вставить( "a", 65   );
	КодыАнгл.Вставить( "s", 83   );
	КодыАнгл.Вставить( "d", 68   );
	КодыАнгл.Вставить( "f", 70   );
	КодыАнгл.Вставить( "g", 71   );
	КодыАнгл.Вставить( "h", 72   );
	КодыАнгл.Вставить( "j", 74   );
	КодыАнгл.Вставить( "k", 75   );
	КодыАнгл.Вставить( "l", 76   );
	КодыАнгл.Вставить( ";", 186  );
	КодыАнгл.Вставить( """", 222 );
	КодыАнгл.Вставить( "z", 90   );
	КодыАнгл.Вставить( "x", 88   );
	КодыАнгл.Вставить( "c", 67   );
	КодыАнгл.Вставить( "v", 86   );
	КодыАнгл.Вставить( "b", 66   );
	КодыАнгл.Вставить( "n", 78   );
	КодыАнгл.Вставить( "m", 77   );
	КодыАнгл.Вставить( ",", 188  );
	КодыАнгл.Вставить( ".", 190  );
	КодыАнгл.Вставить( "/", 191  );
	КодыАнгл.Вставить( "~" , 192 );
	КодыАнгл.Вставить( "!" , 49  );
	КодыАнгл.Вставить( "@" , 50  );
	КодыАнгл.Вставить( "#" , 51  );
	КодыАнгл.Вставить( "$" , 52  );
	КодыАнгл.Вставить( "%" , 53  );
	КодыАнгл.Вставить( "^" , 54  );
	КодыАнгл.Вставить( "&" , 55  );
	КодыАнгл.Вставить( "*" , 56  );
	КодыАнгл.Вставить( "(" , 57  );
	КодыАнгл.Вставить( ")" , 48  );
	КодыАнгл.Вставить( "_" , 189 );
	КодыАнгл.Вставить( "+" , 187 );
	КодыАнгл.Вставить( "(", 219  );
	КодыАнгл.Вставить( ")", 221  );
	КодыАнгл.Вставить( ":", 186  );
	КодыАнгл.Вставить( "<", 188  );
	КодыАнгл.Вставить( ">", 190  );
	КодыАнгл.Вставить( "?", 191  );

	КодыРус = Новый Соответствие();
	КодыРус.Вставить( "ё" , 192 );
	КодыРус.Вставить( "1" , 49  );
	КодыРус.Вставить( "2" , 50  );
	КодыРус.Вставить( "3" , 51  );
	КодыРус.Вставить( "4" , 52  );
	КодыРус.Вставить( "5" , 53  );
	КодыРус.Вставить( "6" , 54  );
	КодыРус.Вставить( "7" , 55  );
	КодыРус.Вставить( "8" , 56  );
	КодыРус.Вставить( "9" , 57  );
	КодыРус.Вставить( "0" , 48  );
	КодыРус.Вставить( "-" , 189 );
	КодыРус.Вставить( "=" , 187 );
	КодыРус.Вставить( "й" , 81  );
	КодыРус.Вставить( "ц" , 87  );
	КодыРус.Вставить( "у" , 69  );
	КодыРус.Вставить( "к" , 82  );
	КодыРус.Вставить( "е" , 84  );
	КодыРус.Вставить( "н" , 89  );
	КодыРус.Вставить( "г" , 85  );
	КодыРус.Вставить( "ш" , 73  );
	КодыРус.Вставить( "щ" , 79  );
	КодыРус.Вставить( "з" , 80  );
	КодыРус.Вставить( "х" , 219 );
	КодыРус.Вставить( "ъ" , 221 );
	КодыРус.Вставить( "ф" , 65  );
	КодыРус.Вставить( "ы" , 83  );
	КодыРус.Вставить( "в" , 68  );
	КодыРус.Вставить( "а" , 70  );
	КодыРус.Вставить( "п" , 71  );
	КодыРус.Вставить( "р" , 72  );
	КодыРус.Вставить( "о" , 74  );
	КодыРус.Вставить( "л" , 75  );
	КодыРус.Вставить( "д" , 76  );
	КодыРус.Вставить( "ж" , 186 );
	КодыРус.Вставить( "э" , 222 );
	КодыРус.Вставить( "я" , 90  );
	КодыРус.Вставить( "ч" , 88  );
	КодыРус.Вставить( "с" , 67  );
	КодыРус.Вставить( "м" , 86  );
	КодыРус.Вставить( "и" , 66  );
	КодыРус.Вставить( "т" , 78  );
	КодыРус.Вставить( "ь" , 77  );
	КодыРус.Вставить( "б" , 188 );
	КодыРус.Вставить( "ю" , 190 );
	КодыРус.Вставить( "." , 191 );
	КодыРус.Вставить( "!" , 49  );
	КодыРус.Вставить( """" , 50 );
	КодыРус.Вставить( "№" , 51  );
	КодыРус.Вставить( ";" , 52  );
	КодыРус.Вставить( "%" , 53  );
	КодыРус.Вставить( ":" , 54  );
	КодыРус.Вставить( "?" , 55  );
	КодыРус.Вставить( "*" , 56  );
	КодыРус.Вставить( "(" , 57  );
	КодыРус.Вставить( ")" , 48  );
	КодыРус.Вставить( "_" , 189 );
	КодыРус.Вставить( "+" , 187 );
	КодыРус.Вставить( "," , 191 );

	ВсеКоды = Новый Соответствие();
	Для Каждого КиЗ из КодыАнгл Цикл
		ВсеКоды.Вставить(КиЗ.Ключ, КиЗ.Значение);
	КонецЦикла;
	Для Каждого КиЗ из КодыРус Цикл
		ВсеКоды.Вставить(КиЗ.Ключ, КиЗ.Значение);
	КонецЦикла;

	СоответствияКодов = Новый Соответствие();
	СоответствияКодов.Вставить( 192 , НовыйМассив(" 49 "));
	СоответствияКодов.Вставить( 49  , НовыйМассив(" 50, 87, 81 "));
	СоответствияКодов.Вставить( 50  , НовыйМассив(" 49, 81, 87, 69, 51 "));
	СоответствияКодов.Вставить( 51  , НовыйМассив(" 50, 87, 69, 82, 52 "));
	СоответствияКодов.Вставить( 52  , НовыйМассив(" 51, 69, 82, 84, 53 "));
	СоответствияКодов.Вставить( 53  , НовыйМассив(" 52, 82, 84, 89, 54 "));
	СоответствияКодов.Вставить( 54  , НовыйМассив(" 53, 84, 89, 85, 55 "));
	СоответствияКодов.Вставить( 55  , НовыйМассив(" 54, 89, 85, 73, 56 "));
	СоответствияКодов.Вставить( 56  , НовыйМассив(" 55, 85, 73, 79, 57 "));
	СоответствияКодов.Вставить( 57  , НовыйМассив(" 56, 73, 79, 80, 48 "));
	СоответствияКодов.Вставить( 48  , НовыйМассив(" 57, 79, 80, 219, 189 "));
	СоответствияКодов.Вставить( 189 , НовыйМассив(" 48, 80, 219, 221, 187 "));
	СоответствияКодов.Вставить( 187 , НовыйМассив(" 189, 219, 221 "));
	СоответствияКодов.Вставить( 81  , НовыйМассив(" 49, 50, 87, 83, 65 "));
	СоответствияКодов.Вставить( 87  , НовыйМассив(" 49, 81, 65, 83, 68, 69, 51, 50 "));
	СоответствияКодов.Вставить( 69  , НовыйМассив(" 50, 87, 83, 68, 70, 82, 52, 51 "));
	СоответствияКодов.Вставить( 82  , НовыйМассив(" 51, 69, 68, 70, 71, 84, 53, 52 "));
	СоответствияКодов.Вставить( 84  , НовыйМассив(" 52, 82, 70, 71, 72, 89, 54, 53 "));
	СоответствияКодов.Вставить( 89  , НовыйМассив(" 53, 84, 71, 72, 74, 85, 55, 54 "));
	СоответствияКодов.Вставить( 85  , НовыйМассив(" 54, 89, 72, 74, 75, 73, 56, 55 "));
	СоответствияКодов.Вставить( 73  , НовыйМассив(" 55, 85, 74, 75, 76, 79, 57, 56 "));
	СоответствияКодов.Вставить( 79  , НовыйМассив(" 56, 73, 75, 76, 186, 80, 48, 57 "));
	СоответствияКодов.Вставить( 80  , НовыйМассив(" 57, 79, 76, 186, 222, 219, 189, 48 "));
	СоответствияКодов.Вставить( 219 , НовыйМассив(" 48, 186, 222, 221, 187, 189 "));
	СоответствияКодов.Вставить( 221 , НовыйМассив(" 189, 219, 187 "));
	СоответствияКодов.Вставить( 65  , НовыйМассив(" 81, 87, 83, 88, 90 "));
	СоответствияКодов.Вставить( 83  , НовыйМассив(" 81, 65, 90, 88, 67, 68, 69, 87, 81 "));
	СоответствияКодов.Вставить( 68  , НовыйМассив(" 87, 83, 88, 67, 86, 70, 82, 69 "));
	СоответствияКодов.Вставить( 70  , НовыйМассив(" 69, 68, 67, 86, 66, 71, 84, 82 "));
	СоответствияКодов.Вставить( 71  , НовыйМассив(" 82, 70, 86, 66, 78, 72, 89, 84 "));
	СоответствияКодов.Вставить( 72  , НовыйМассив(" 84, 71, 66, 78, 77, 74, 85, 89 "));
	СоответствияКодов.Вставить( 74  , НовыйМассив(" 89, 72, 78, 77, 188, 75, 73, 85 "));
	СоответствияКодов.Вставить( 75  , НовыйМассив(" 85, 74, 77, 188, 190, 76, 79, 73 "));
	СоответствияКодов.Вставить( 76  , НовыйМассив(" 73, 75, 188, 190, 191, 186, 80, 79 "));
	СоответствияКодов.Вставить( 186 , НовыйМассив(" 79, 76, 190, 191, 222, 219, 80 "));
	СоответствияКодов.Вставить( 222 , НовыйМассив(" 80, 186, 191, 221, 219 "));
	СоответствияКодов.Вставить( 90  , НовыйМассив(" 65, 83, 88 "));
	СоответствияКодов.Вставить( 88  , НовыйМассив(" 90, 65, 83, 68, 67 "));
	СоответствияКодов.Вставить( 67  , НовыйМассив(" 88, 83, 68, 70, 86 "));
	СоответствияКодов.Вставить( 86  , НовыйМассив(" 67, 68, 70, 71, 66 "));
	СоответствияКодов.Вставить( 66  , НовыйМассив(" 86, 70, 71, 72, 78 "));
	СоответствияКодов.Вставить( 78  , НовыйМассив(" 66, 71, 72, 74, 77 "));
	СоответствияКодов.Вставить( 77  , НовыйМассив(" 78, 72, 74, 75, 188 "));
	СоответствияКодов.Вставить( 188 , НовыйМассив(" 77, 74, 75, 76, 190 "));
	СоответствияКодов.Вставить( 190 , НовыйМассив(" 188, 75, 76, 186, 191 "));
	СоответствияКодов.Вставить( 191 , НовыйМассив(" 190, 76, 186, 222 "));

	ФонетическаяГруппаРус = СоздатьФонетическуюГруппу(НовыйМассив("ыий, эе, ая, оёе, ую, шщ, оа", Ложь));
	ФонетическаяГруппаАнг = СоздатьФонетическуюГруппу(НовыйМассив("aeiouy, bp, ckq, dt, lr, mn, gj, fpv, sxz, csz", Ложь));

КонецПроцедуры

Функция СоздатьФонетическуюГруппу(ГруппыСимволов)
	Результат = Новый Соответствие();
	Для Каждого ТекГруппа из ГруппыСимволов Цикл
		Для Каждого ТекСимвол из РазбитьСтрокуНаСимволы(ТекГруппа) Цикл
			Если Результат.Получить(ТекСимвол) = Неопределено Тогда
				Результат.Вставить(ТекСимвол, МассивСловБезДублейСОтбором(ТекСимвол, ГруппыСимволов));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Возврат Результат;	
КонецФункции

Функция МассивСловБезДублейСОтбором(Отбор, СписокСлов)
	Результат = Новый Массив();
	ВремСоотв = Новый Соответствие();
	Для Каждого ТекСлово из СписокСлов Цикл
		Если СтрНайти(ТекСлово, Отбор) > 0 Тогда
			Для каждого ТекСимвол Из РазбитьСтрокуНаСимволы(ТекСлово) Цикл
				Если не Отбор = ТекСимвол Тогда
					ВремСоотв.Вставить(ТекСимвол);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	Для каждого КиЗ Из ВремСоотв Цикл
		Результат.Добавить(КиЗ.Ключ);	
	КонецЦикла;

	Возврат Результат;	
КонецФункции

Функция РазбитьСтрокуНаСимволы(Строка)
	Результат = Новый Массив();
	Для Сч = 1 По СтрДлина(Строка) Цикл
		Результат.Добавить(Сред(Строка, Сч, 1));	
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция НовыйМассив(СтрокаЧиселПараметров, ПревестиКЧислу = Истина)
	Результат = Новый Массив();

	Для Каждого ТекЧисло из СтрРазделить(СтрокаЧиселПараметров, ",") Цикл
		Значение = СокрЛП(ТекЧисло);
		Если ПревестиКЧислу = Истина Тогда
			Значение = Число(Значение);
		КонецЕсли;
		Результат.Добавить(Значение);
	КонецЦикла;

	Возврат Результат;
КонецФункции