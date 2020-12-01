# WeatherAppSwift
App that works with Weather API by Vladislav Permyakov

WeatherAppSwift/ContentView.swift - главный файл с дизайном основного окна и парсером-декодером-реквестером

внутри var body: some View {} это дизайн основного окна приложения, всё что выше - основная программа

WeatherClass.swift - класс с информацией самой погоды
ErrorClass.swift - класс для обработки ошибокй, получаемых от API, например 404 при вооде не правильной информации об искомом городе
