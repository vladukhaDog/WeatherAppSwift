//
//  ContentView.swift
//  WeatherAppSwift
//
//  Created by vladukha on 01.12.2020.
//

import SwiftUI

struct ContentView: View {
	
	func infoForKey(_ key: String) -> String? {
			return (Bundle.main.infoDictionary?[key] as? String)?
				.replacingOccurrences(of: "\\", with: "")
	 }
	
	func setAlert(ErrorCode: String, ErrorMessage: String) // метод отображения ошибки пользователю
	{
		self.isError = ErrorCode // передаём в переменные дезигна тайтл и сообщение алерта
		self.ErrorMessage = ErrorMessage
		self.showingAlert = true //свойство показывать ли сейчас алерт или нет
	}
	
	func GetJson() {
		let apiKey:String = ProcessInfo.processInfo.environment["API_KEY"] ?? "0"
		if apiKey == "0"
		{
			setAlert(ErrorCode: "BUILD ERROR", ErrorMessage: "API KEY IS NOT DEFINED IN BUILD SETTINGS")
			return
		}
		let jsonURLString = "http://api.openweathermap.org/data/2.5/weather?id="+String(self.CityID)+"&appid="+String(apiKey)+"&units=metric"
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
				self.City = weather.name ?? "no city"
				//print(weather.clouds?.all ?? "no gay")
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
	
	let botThread = Thread {
		UserDefaults.standard.set(true, forKey: "canUpdate")
		print("BotStarted!")
		while true
		{
			if let canUpdate = UserDefaults.standard.object(forKey: "canUpdate") {
				if (canUpdate as! Bool) //если последний на последний апдейт всё отвечено
				{
					getUpdate()
					sleep(1)
				}
			}
		}
	}
	
	@State private var showingAlert = false
	@State private var ErrorMessage: String = ""
	@State private var isError: String = ""
	//-----
	@State private var City = "City"
	@State private var wind = 0.0
	@State private var feelsLike = 0.0
	@State private var temperature = 0.0
	@State private var CityID: String = "498817"
    var body: some View {
		ZStack{
			BackgroundView()
			VStack(alignment: .center)
			{
				TextField(
					"Enter your city ID",
					text: $CityID,
					onCommit: {
								GetJson()
							 }
				)
					.padding()
					.frame(alignment: .center)
					.foregroundColor(.gray)
				
				Text(String(City))
					.font(.system(size: 60))
					.fontWeight(.ultraLight)
					.foregroundColor(.white)
				HStack
				{
					Text(String(temperature*10))
						.font(.system(size: 80))
						.fontWeight(.ultraLight)
						.foregroundColor(.white)
					VStack
					{
						Text("Feels like \(String(feelsLike)) C")
						Text("Wind is \(String(wind)) m/s")
					}
					.foregroundColor(.white)
				}
				.padding()
				.multilineTextAlignment(.center)
				.onAppear(perform: {GetJson()
					botThread.start()
				})	//при появлении экрана, обновить данные
				Spacer()
			}
		}
		
		.alert(isPresented: $showingAlert) { // если нужно показывать алерт, то оно показывает алерт (внаутре круто как так то)
			Alert(title: Text(isError), message: Text(ErrorMessage), dismissButton: .default(Text("i got it!")))
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
