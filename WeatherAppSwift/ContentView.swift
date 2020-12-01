//
//  ContentView.swift
//  WeatherAppSwift
//
//  Created by vladukha on 01.12.2020.
//

import SwiftUI

struct ContentView: View {
	
	func setAlert(ErrorCode: String, ErrorMessage: String) // метод отображения ошибки пользователю
	{
		self.isError = ErrorCode // передаём в переменные дезигна тайтл и сообщение алерта
		self.ErrorMessage = ErrorMessage
		self.showingAlert = true //свойство показывать ли сейчас алерт или нет
	}
	
	func GetJson() {
		let jsonURLString = "http://api.openweathermap.org/data/2.5/weather?id="+String(self.CityID)+"&appid=5f86955253d2a674d9105d4b7e130fca&units=metric"
		guard let url = URL(string: jsonURLString) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in //Стартуем сессию подключения к ссылке API
			if error != nil {
				print(error!.localizedDescription) // если в ошибке что-то есть, то надо бы вывести эту ошибочку
			}
			guard let data = data else { return } // если в дате что-то есть, то кайфуем
			do {
				let weather = try JSONDecoder().decode(Weather.self, from: data)
				self.temperature = weather.main?.temp ?? 0.0	//после декода пихаем значения в переменные дезигна и пихаем значения нулёвки, если в джсоне получен nil
				self.wind = weather.wind?.speed ?? 0.0
				self.feelsLike = weather.main?.feelsLike ?? 0.0
			} catch {
				do
				{
					let errore = try JSONDecoder().decode(WeatherError.self, from: data) // если не смогли декоднуть в класс погоды, пробуем в класс ошибки от API
					setAlert(ErrorCode: errore.cod ?? "0", ErrorMessage: errore.message ?? "") // передаём код и сообщение ошибки в метод
					
				} catch let errorr
				{	//если не получилось декоднуть и в класс ошибки, значит вообще всё умерло нахрен, передаём соответствующую парашу инфу об этом
					setAlert(ErrorCode: "Unexpected!", ErrorMessage: "There was an error getting information")
					print(errorr)
				}
			}
			
		}.resume()
	}
	@State public var showingAlert = false
	@State public var ErrorMessage: String = ""
	@State public var isError: String = ""
	//-----
	@State public var wind = 0.0
	@State public var feelsLike = 0.0
	@State public var temperature = 0.0
	@State public var CityID: String = "498817"
    var body: some View {
		VStack(alignment: .center)
		{
			TextField("Enter your city ID", text: $CityID)
				.padding()
				.frame(alignment: .center)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.background(Color.blue)
			VStack
			{
				Text("Current temperature is \(String(temperature)) Celcius")
				Text("But it feels like \(String(feelsLike)) degrees.")
				Text("The wind speed is \(String(wind)) meters per second right now!")
			}
			.padding()
			.multilineTextAlignment(.center)
			
			Button(action: {
					GetJson() // по нажатию кнопку обновить данные
			}) {
					Text("Update")
			}
			.onAppear(perform: {GetJson()})	//при появлении экрана, обновить данные
			.alert(isPresented: $showingAlert) { // если нужно показывать алерт, то оно показывает алерт (внаутре круто как так то)
				Alert(title: Text(isError), message: Text(ErrorMessage), dismissButton: .default(Text("i got it!")))
					
}
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
