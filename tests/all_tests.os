#Использовать asserts
#Использовать ".."

Функция РасчитатьИдентичность(Иголка, Стог, УчитыватьРегистр = Ложь)

	Поиск = Новый Поиск();	
	Возврат Поиск.РасчитатьИдентичность(Иголка, Стог, УчитыватьРегистр);

КонецФункции

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

    ВсеТесты = Новый Массив;    
    ВсеТесты.Добавить("ТестДолжен_ПроверитьФункциюПоискаСовпадений_ТочныеСовпадения");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьФункциюПоискаСовпадений_СпецСимволы");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьФункциюПоискаСовпадений_ЧастичныеСовпадения");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьФункциюПоискаСовпадений_Разделители");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьФункциюПоискаСовпадений_ПустойЗапрос");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьФункциюПоискаСовпадений_Несовпадения");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетНачалаСлова");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетПоследовательности");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетКротчайшемуСовпадению");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_ПредпочтениеБлижайшемуКондидату");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетСовпаденияВНачале");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_КорректнаяОбработкаСлешей");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРасчетИдентичности_ОбработкаВерблюжейНотации");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьОбработкуКоллекций");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьПоискВнайденном");
	
    Возврат ВсеТесты;

КонецФункции

Процедура ПередЗапускомТеста() Экспорт
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
КонецПроцедуры

Процедура ТестДолжен_ПроверитьФункциюПоискаСовпадений_ТочныеСовпадения() Экспорт

    Поиск = Новый Поиск();

	Проверям = "Точные совпадения";
	Ожидаем.Что(Поиск.ЕстьСовпадения("a", "a"), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("a", "a", Истина), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("A", "A", Истина), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("a.bb", "a.bb"), Проверям).Равно(Истина);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьФункциюПоискаСовпадений_СпецСимволы() Экспорт

    Поиск = Новый Поиск();

	Проверям = "Спец символы";
	Ожидаем.Что(Поиск.ЕстьСовпадения("\\", "\\"), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("/", "/"), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("[", "["), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("%", "%"), Проверям).Равно(Истина);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьФункциюПоискаСовпадений_ЧастичныеСовпадения() Экспорт

    Поиск = Новый Поиск();

	Проверям = "Частичные совпдания";

	Ожидаем.Что(Поиск.ЕстьСовпадения("a", "ab"), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("a", "ba"), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("aba", "baabbaab"), Проверям).Равно(Истина);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьФункциюПоискаСовпадений_Разделители() Экспорт

    Поиск = Новый Поиск();

	Проверям = "Проверка разделителей";

	Ожидаем.Что(Поиск.ЕстьСовпадения("abc", "a|b|c"), Проверям).Равно(Истина);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьФункциюПоискаСовпадений_ПустойЗапрос() Экспорт

    Поиск = Новый Поиск();

	Проверям = "Обработка пустого запроса";

	Ожидаем.Что(Поиск.ЕстьСовпадения("", ""), Проверям).Равно(Истина);
    Ожидаем.Что(Поиск.ЕстьСовпадения("", "a"), Проверям).Равно(Истина);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьФункциюПоискаСовпадений_Несовпадения() Экспорт

    Поиск = Новый Поиск();

	Проверям = "Обработка несовпадений";

	Ожидаем.Что(Поиск.ЕстьСовпадения("a", ""), Проверям).Равно(Ложь);
    Ожидаем.Что(Поиск.ЕстьСовпадения("a", "b"), Проверям).Равно(Ложь);
    Ожидаем.Что(Поиск.ЕстьСовпадения("aa", "a"), Проверям).Равно(Ложь);
    Ожидаем.Что(Поиск.ЕстьСовпадения("ba", "a"), Проверям).Равно(Ложь);
    Ожидаем.Что(Поиск.ЕстьСовпадения("ab", "a"), Проверям).Равно(Ложь);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетНачалаСлова() Экспорт

	Проверям = "Приоритет по начало слова";

	Ожидаем.Что(РасчитатьИдентичность("amor", "app/models/order"), Проверям).Больше(РасчитатьИдентичность("amor", "app/models/zrder"));
	Ожидаем.Что(РасчитатьИдентичность("amor", "app models order"), Проверям).Больше(РасчитатьИдентичность("amor", "app models zrder"));
	Ожидаем.Что(РасчитатьИдентичность("amor", "appModelsOrder"), Проверям).Больше(РасчитатьИдентичность("amor", "appModelsZrder"));
	Ожидаем.Что(РасчитатьИдентичность("amor", "app\\models\\order"), Проверям).Больше(РасчитатьИдентичность("amor", "app\\models\\zrder"));
	Ожидаем.Что(РасчитатьИдентичность("a", ".a"), Проверям).Больше(РасчитатьИдентичность("a", "ba"));

КонецПроцедуры

Процедура ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетПоследовательности() Экспорт

	Проверям = "Приоритет по последовательности";

	Ожидаем.Что(РасчитатьИдентичность("amo", "app/models/foo"), Проверям).Больше(РасчитатьИдентичность("amo", "app/m/foo"));
	Ожидаем.Что(РасчитатьИдентичность("amo", "app/models/foo"), Проверям).Больше(РасчитатьИдентичность("amo", "app/m/o"));
	Ожидаем.Что(РасчитатьИдентичность("erf", "perfect"), Проверям).Больше(РасчитатьИдентичность("erf", "terrific"));
	Ожидаем.Что(РасчитатьИдентичность("abc", "*ab**c*"), Проверям).Больше(РасчитатьИдентичность("abc", "*a*b*c*"));
	Ожидаем.Что(РасчитатьИдентичность("gemfil", "Gemfile"), Проверям).Больше(РасчитатьИдентичность("gemfil", "Gemfile.lock"));

КонецПроцедуры

////*
Процедура ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетКротчайшемуСовпадению() Экспорт

	Проверям = "Приоритет по коротчайшему совпадению";
	
Ожидаем.Что(РасчитатьИдентичность("abce", "abcdef"), Проверям).Больше(РасчитатьИдентичность("abce", "abc de"));
Ожидаем.Что(РасчитатьИдентичность("abc", "    a b c "), Проверям).Больше(РасчитатьИдентичность("abc", " a  b  c "));
Ожидаем.Что(РасчитатьИдентичность("abc", " a b c    "), Проверям).Больше(РасчитатьИдентичность("abc", " a  b  c "));
Ожидаем.Что(РасчитатьИдентичность("aa", "*a*a*"), Проверям).Больше(РасчитатьИдентичность("aa", "*a**a"));

КонецПроцедуры

Процедура ТестДолжен_ПроверитьРасчетИдентичности_ПредпочтениеБлижайшемуКондидату() Экспорт

		Проверям = "Предпочтение БлижайшемуКондидату ";
		
	Ожидаем.Что(РасчитатьИдентичность("test", "tests"), Проверям).Больше(РасчитатьИдентичность("test", "testing"));

КонецПроцедуры

Процедура ТестДолжен_ПроверитьРасчетИдентичности_ПриоритетСовпаденияВНачале() Экспорт

	Проверям = "Приоритет Совпадения В Начале";
	
	Ожидаем.Что(РасчитатьИдентичность("ab", "abbb"), Проверям).Больше(РасчитатьИдентичность("ab", "babb"));
	Ожидаем.Что(РасчитатьИдентичность("test", "testing"), Проверям).Больше(РасчитатьИдентичность("test", "/testing"));

КонецПроцедуры

Процедура ТестДолжен_ПроверитьРасчетИдентичности_КорректнаяОбработкаСлешей() Экспорт

	Проверям = "Корректная обработка слешей";
	
	Ожидаем.Что(РасчитатьИдентичность("a", "*/a"), Проверям).Больше(РасчитатьИдентичность("a", "**a"));
	Ожидаем.Что(РасчитатьИдентичность("a", "*\\a"), Проверям).Больше(РасчитатьИдентичность("a", "**a"));
	Ожидаем.Что(РасчитатьИдентичность("a", "**/a"), Проверям).Больше(РасчитатьИдентичность("a", "*a"));
	Ожидаем.Что(РасчитатьИдентичность("a", "**\\a"), Проверям).Больше(РасчитатьИдентичность("a", "*a"));
	Ожидаем.Что(РасчитатьИдентичность("aa", "a/aa"), Проверям).Больше(РасчитатьИдентичность("aa", "a/a"));

КонецПроцедуры

 Процедура ТестДолжен_ПроверитьРасчетИдентичности_ОбработкаВерблюжейНотации() Экспорт

	Проверям = "Обработка верблюжей нотации";
	
	Ожидаем.Что(РасчитатьИдентичность("a", "bA"), Проверям).Больше(РасчитатьИдентичность("a", "ba"));
	Ожидаем.Что(РасчитатьИдентичность("a", "baA"), Проверям).Больше(РасчитатьИдентичность("a", "ba"));

КонецПроцедуры

Функция НайтиВКоллекции(Коллекция, Значение, Количество, Ключ)

	Поиск = Новый Поиск();
	Поиск.ЗагрузитьДанные(Коллекция);

	Возврат Поиск.НайтиЗначенияИлиКлючи(Значение, Количество, Ключ);
	
КонецФункции

Процедура ТестДолжен_ПроверитьОбработкуКоллекций() Экспорт

	ТестовыйНабор = Новый Соответствие();

	Массив = Новый Массив();
	Массив.Добавить("app/models/user.rb");
	Массив.Добавить("app/models/customer.rb");
	Массив.Добавить("app/models/block");

	ТестовыйНабор.Вставить(Массив, Новый Структура("Проверка, ЛучшееСовпадение, ЛучшийКлюч", 
													"Проверка массива",
													"app/models/user.rb",
													0));

	Структура = Новый Структура("Каталог1, Каталог2, Каталог3",
					"app/models/user.rb",
					"app/models/customer.rb",
	 				"app/models/block");

	ТестовыйНабор.Вставить(Структура, Новый Структура("Проверка, ЛучшееСовпадение, ЛучшийКлюч", 
													"Проверка структура",
													"app/models/user.rb",
													"Каталог1"));

	Соответствие = Новый Соответствие();
	Соответствие.Вставить(0,"app/models/user.rb");
	Соответствие.Вставить(1,"app/models/customer.rb");
	Соответствие.Вставить(2,"app/models/block");

	ТестовыйНабор.Вставить(Соответствие, Новый Структура("Проверка, ЛучшееСовпадение, ЛучшийКлюч", 
													"Проверка соответствия",
													"app/models/user.rb",
													0));

	ТЗ = Новый ТаблицаЗначений();
	ТЗ.Колонки.Добавить("Каталог");
	ТЗ.Колонки.Добавить("ГУИД");

	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.Каталог = "app/models/user.rb";
	Новаястрока.ГУИД = "123";

	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.Каталог = "app/models/customer.rb";
	Новаястрока.ГУИД = "456";

	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.Каталог = "app/models/block";
	Новаястрока.ГУИД = "789";

	ТестовыйНабор.Вставить(ТЗ, Новый Структура("Проверка, ЛучшееСовпадение, ЛучшийКлюч", 
													"Проверка таблицы значений",
													"app/models/user.rb,123",
													ТЗ[0]));

	Для Каждого КиЗ из ТестовыйНабор Цикл
		
		Проверям = КиЗ.Значение.Проверка + " возвращено две строки";
		Ожидаем.Что(НайтиВКоллекции(КиЗ.Ключ, "amuser", 0, Ложь).Количество(), Проверям).Равно(2);

		Проверям = КиЗ.Значение.Проверка + " возвращено app/models/user.rb";
		Ожидаем.Что(НайтиВКоллекции(КиЗ.Ключ, "amuser", 1, Ложь), Проверям).Равно(КиЗ.Значение.ЛучшееСовпадение);

		Проверям = КиЗ.Значение.Проверка + " ключ 0";
		Ожидаем.Что(НайтиВКоллекции(КиЗ.Ключ, "amuser", 1, Истина), Проверям).Равно(КиЗ.Значение.ЛучшийКлюч);

		Проверям = КиЗ.Значение.Проверка + " возвращено массив значений, и первый элемент искомый";
		Ожидаем.Что(НайтиВКоллекции(КиЗ.Ключ, "amuser", 10, Ложь)[0], Проверям).Равно(КиЗ.Значение.ЛучшееСовпадение);

		Проверям = КиЗ.Значение.Проверка + " не найдено массив";
		Ожидаем.Что(НайтиВКоллекции(КиЗ.Ключ, "no match", 5, Ложь).Количество(), Проверям).Равно(0);

		Проверям = КиЗ.Значение.Проверка + " не найдено неопределено";
		Ожидаем.Что(НайтиВКоллекции(КиЗ.Ключ, "no match", 1, Ложь), Проверям).Равно(Неопределено);

	КонецЦикла;
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПоискВнайденном() Экспорт

    Поиск = Новый Поиск();

	Массив = Новый Массив();
	Массив.Добавить("app/models/user.rc");
	Массив.Добавить("app/models/customer.rb");
	Массив.Добавить("app/models/block.rc");

	Поиск.ЗагрузитьДанные(Массив);

	Проверям = "поиск в найденном, первая выборка";
	Ожидаем.Что(Поиск.НайтиЗначенияИлиКлючи("amuser").Количество(), Проверям).Равно(2);

	Поиск.ИскатьВНайденном = Истина;

	Проверям = "поиск в найденном, вторая выборка";
	Ожидаем.Что(Поиск.НайтиЗначенияИлиКлючи("rc").Количество(), Проверям).Равно(1);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗагрузкуДанныхЧерезКонструктор() Экспорт

    Массив = Новый Массив();
	Массив.Добавить("app/models/user.rc");
	Массив.Добавить("app/models/customer.rb");
	Массив.Добавить("app/models/block.rc");

	Поиск = Новый Поиск(Массив);

	Проверям = "Загрука данных через конструктор, и попытка поиска";
	Ожидаем.Что(Поиск.НайтиЗначенияИлиКлючи("amuser").Количество(), Проверям).Равно(2);

КонецПроцедуры



