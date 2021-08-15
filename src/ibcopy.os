#Использовать TRun1C
#Использовать configor
#Использовать logos

#Область ОписаниеПеременных

Перем КонтекстВыгрузки;
Перем КонтекстЗагрузки;
Перем КаталогКопий;
Перем ПутьКФайлуКопии;
Перем НастройкиОбщие;
Перем ТолькоВыгрузка;
Перем ВерсияПрилоения;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ПолезнаяРабота()
	ЗагрузитьНастройки();
	СформироватьИмяКопии();	
	ВыгрузитьБазу();
	Если Не ТолькоВыгрузка Тогда
		ЗагрузитьБазу();
	КонецЕсли;
КонецПроцедуры

Процедура ЗагрузитьНастройки()

	МенеджерПараметров = Новый МенеджерПараметров();
	МенеджерПараметров.АвтоНастройка("config");
	МенеджерПараметров.УстановитьФайлПараметров("env.json");
	МенеджерПараметров.Прочитать();
	
	Если МенеджерПараметров.ЧтениеВыполнено() Тогда
		НастройкиОбщие = МенеджерПараметров.Параметр("Настройки.Общие");
		
		КаталогКопий = НастройкиОбщие["КаталогКопий"];
		ТолькоВыгрузка = НастройкиОбщие["ТолькоВыгрузка"];
		НастройкиКонтекстВыгрузки = МенеджерПараметров.Параметр("Настройки.КонтекстВыгрузки");
		ЗаполнитьКонтекст(КонтекстВыгрузки, НастройкиКонтекстВыгрузки);
		Если Не ТолькоВыгрузка Тогда
			НастройкиКонтекстЗагрузки = МенеджерПараметров.Параметр("Настройки.КонтекстЗагрузки");
			ЗаполнитьКонтекст(КонтекстЗагрузки, НастройкиКонтекстЗагрузки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
Процедура ЗаполнитьКонтекст(Контекст, Настройки)
	
	Контекст = Новый ТУправлениеЗапуском1С();

	Для Каждого Элем Из Настройки Цикл
		Контекст.ПараметрыЗапуска[Элем.Ключ] = Элем.Значение;
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьИмяКопии()

	ИмяФайлаКопии = КонтекстВыгрузки.ИмяФайлаПоИмениБазыНаДату("dt");
	ПутьКФайлуКопии = ОбъединитьПути(КаталогКопий, ИмяФайлаКопии);

КонецПроцедуры
#КонецОбласти

Процедура ВыгрузитьБазу()
	Если НастройкиОбщие["ЗавершатьСеансы"] Тогда
		КонтекстВыгрузки.ЗавершитьРаботуПользователей();
	КонецЕсли;
	КонтекстВыгрузки.ВыгрузитьИнформационнуюБазу(ПутьКФайлуКопии);
КонецПроцедуры

Процедура ЗагрузитьБазу()
	КонтекстЗагрузки.ЗагрузитьИнформационнуюБазу(ПутьКФайлуКопии);
КонецПроцедуры

ВерсияПриложения = "0.2 alpha";
ПолезнаяРабота();