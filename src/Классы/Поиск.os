Перем SCORE_GAP_LEADING;
Перем SCORE_GAP_TRAILING;
Перем SCORE_GAP_INNER;
Перем SCORE_MATCH_CONSECUTIVE;
Перем SCORE_MATCH_SLASH;
Перем SCORE_MATCH_WORD;
Перем SCORE_MATCH_CAPITAL;
Перем SCORE_MATCH_DOT;
Перем SCORE_MAX;
Перем SCORE_MIN;
Перем MATCH_MAX_LENGTH;

Процедура ПриСозданииОбъекта()

	SCORE_GAP_LEADING = -0.005;
	SCORE_GAP_TRAILING = -0.005;
	SCORE_GAP_INNER = -0.01;
	SCORE_MATCH_CONSECUTIVE = 1.0;
	SCORE_MATCH_SLASH = 0.9;
	SCORE_MATCH_WORD = 0.8;
	SCORE_MATCH_CAPITAL = 0.7;
	SCORE_MATCH_DOT = 0.6;
	SCORE_MAX = 999999999999999;
	SCORE_MIN = -999999999999999;
	MATCH_MAX_LENGTH = 1024

КонецПроцедуры

Функция СимволСтроки(Строка, Номер) Экспорт
	Возврат Сред(Строка, Номер, 1);
КонецФункции

Функция has_match(needle, haystack, case_sensitive) Экспорт
	Если НЕ case_sensitive Тогда
	  needle = НРег(needle);
	  haystack = НРег(haystack);
	КонецЕсли;
  
	j = 1;
	Для i = 1 По СтрДлина(needle) Цикл
	  j = СтрНайти(haystack, СимволСтроки(needle, i));
	  Если j = 0 Тогда
		Возврат Ложь;
	  Иначе
		j = j + 1;
	  КонецЕсли;
	КонецЦикла;
  
	Возврат Истина;
КонецФункции

Функция ЭтоБуква(СимволБуквы) 
	НаборБукв = "йцукенгшщзхъфывапролджэячсмитьбюqwertyuiopasdfghjklzxcvbn";
	Возврат СтрНайти(НаборБукв, НРег(СимволБуквы)) > 0;
КонецФункции

Функция is_lower(c) Экспорт
	Возврат ?(ЭтоБуква(c), c = НРег(c), Ложь);
КонецФункции

Функция is_upper(c) Экспорт
	Возврат ?(ЭтоБуква(c), c = ВРег(c), Ложь);
КонецФункции

Функция precompute_bonus(haystack) Экспорт
  match_bonus = Новый Соответствие();

  last_char = "/";
  Для i = 1 по СтрДлина(haystack) Цикл
    this_char = СимволСтроки(haystack,i);
    Если last_char = "/" или last_char = "\\" Тогда
      match_bonus.Вставить(i, SCORE_MATCH_SLASH);
	ИначеЕсли last_char = "-" or last_char = "_" or last_char = " " Тогда
		match_bonus.Вставить(i, SCORE_MATCH_WORD);
    ИначеЕсли last_char = "." Тогда
		match_bonus.Вставить(i, SCORE_MATCH_DOT);
    ИначеЕсли is_lower(last_char) и is_upper(this_char) Тогда
		match_bonus.Вставить(i, SCORE_MATCH_CAPITAL);
	иначе
		match_bonus.Вставить(i, 0);
    КонецЕсли;

    last_char = this_char
  КонецЦикла;

  Возврат match_bonus;
КонецФункции

Функция compute(needle, haystack, D, M, case_sensitive) Экспорт
	match_bonus = precompute_bonus(haystack);
	_n = СтрДлина(needle);
	_m = СтрДлина(haystack);
  
	Если не case_sensitive Тогда
	  needle = НРег(needle);
	  haystack = НРег(haystack);
	КонецЕсли;
  
	haystack_chars = Новый Соответствие();
	Для i = 1 по _m Цикл
	  haystack_chars.Вставить(i, СимволСтроки(haystack, i));
	КонецЦикла;
  
	Для i = 1 по _n Цикл
	  Di = Новый Соответствие();
	  D.Вставить(i, Di);
	  Mi = Новый Соответствие();
	  M.Вставить(i, Mi);
	  
	  prev_score = SCORE_MIN;

	  gap_score = ?(i = _n, SCORE_GAP_TRAILING, SCORE_GAP_INNER);
	  needle_char = СимволСтроки(needle, i);
  
	  Для j = 1 по _m Цикл
		Если needle_char = haystack_chars[j] Тогда
		  score = SCORE_MIN;
		  Если i = 1 Тогда
			score = ((j - 1) * SCORE_GAP_LEADING) + match_bonus[j];
		  ИначеЕсли j > 1 Тогда
			a = M[i - 1][j - 1] + match_bonus[j];
			b = D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE;
			score = МАКС(a, b);
		  КонецЕсли;
		  Di.Вставить(j, score);
		  prev_score = МАКС(score, prev_score + gap_score);
		  Mi.Вставить(j, prev_score);
		Иначе
		  Di.Вставить(j, SCORE_MIN);
		  prev_score = prev_score + gap_score;
		  Mi.Вставить(j, prev_score);
		КонецЕсли;
	  КонецЦикла;
	КонецЦикла;
КонецФункции

Функция score(needle, haystack, case_sensitive = Ложь) Экспорт
	_n = СтрДлина(needle);
	_m = СтрДлина(haystack);
  
	Если _n = 0 ИЛИ _m = 0 ИЛИ _m > MATCH_MAX_LENGTH ИЛИ _n > _m Тогда
	  Возврат SCORE_MIN;
	ИначеЕсли _n = _m 
		И ((case_sensitive = Истина и needle = haystack) ИЛИ
			(case_sensitive = Ложь и НРег(needle) = НРег(haystack)))
		Тогда
	  Возврат SCORE_MAX;
	Иначе
	  D = Новый Соответствие();
	  M = Новый Соответствие();
	  compute(needle, haystack, D, M, case_sensitive);
	  Возврат M[_n][_m];
	КонецЕсли;
КонецФункции

Функция positions(needle, haystack, case_sensitive = Ложь) Экспорт
	_n = СтрДлина(needle);
	_m = СтрДлина(haystack);
  
	Если _n = 0 ИЛИ _m = 0 ИЛИ _m > MATCH_MAX_LENGTH ИЛИ _n > _m Тогда
	  Возврат Новый Структура("Совпадения, Идентичность", Новый Соответствие(), SCORE_MIN);
	ИначеЕсли _n = _m Тогда
	  consecutive = Новый Соответствие();
	  Для i = 1 По _n Цикл
		consecutive.Вставить(i, i);
	  КонецЦикла;
	  Возврат Новый Структура("Совпадения, Идентичность", consecutive, SCORE_MAX);
	КонецЕсли;
  
	D = Новый Соответствие();
	M = Новый Соответствие();
	compute(needle, haystack, D, M, case_sensitive);
  
	positions = Новый Соответствие();
	match_required = Ложь;
	j = _m;
	Для ri = 1 По _n Цикл
		i = _n - (ri-1);
	  Пока j >= 1 Цикл
		Если D[i][j] <> SCORE_MIN И (match_required ИЛИ D[i][j] = M[i][j]) Тогда
		  match_required = (i <> 1) and (j <> 1) И (
		  M[i][j] = D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE);
		  positions.Вставить(i, j);
		  j = j - 1;
		  Прервать;
		Иначе
		  j = j - 1;
		КонецЕсли;
	  КонецЦикла;
	КонецЦикла;
  
	Возврат Новый Структура("Совпадения, Идентичность", positions, M[_n][_m]);
КонецФункции