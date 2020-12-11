//
//  botFunction.swift
//  WeatherAppSwift
//
//  Created by vladukha on 06.12.2020.
//
import Foundation
import UIKit
extension String{
	var encodeUrl : String
	{
		return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
	}
	var decodeUrl : String
	{
		return self.removingPercentEncoding!
	}
}
var lastMessage: [Int: Int] = [:]

func GetWeather(user: Int, CityID: String) {
	let apiKey:String = ProcessInfo.processInfo.environment["API_KEY"] ?? "0"
	if apiKey == "0"
	{
		return
	}
	let jsonURLString = "http://api.openweathermap.org/data/2.5/weather?q="+String(CityID).encodeUrl+"&appid="+String(apiKey)+"&units=metric"
	guard let url = URL(string: jsonURLString) else { return }
	URLSession.shared.dataTask(with: url) { (data, response, error) in //Стартуем сессию подключения к ссылке API
		if error != nil {
			print(error!.localizedDescription) // если в ошибке что-то есть, то надо бы вывести эту ошибочку
		}
		guard let data = data else { return } // если в дате что-то есть, то кайфуем
		do {
			let weather = try JSONDecoder().decode(Weather.self, from: data)
			var message = "temperature is \(weather.main?.temp ?? 0)\n"
			message += "City is \(weather.name ?? "noCity")\n"
			message += "Goodbye"
			sendMessage(user: user, message: message)
		} catch {
			do
			{
				let errore = try JSONDecoder().decode(WeatherError.self, from: data) // если не смогли декоднуть в класс погоды, пробуем в класс ошибки от API
				sendMessage(user: user, message: errore.message ?? "some kind of error on api side")
				
			} catch let errorr
			{	//если не получилось декоднуть и в класс ошибки, значит вообще всё умерло нахрен, передаём соответствующую парашу инфу об этом
				print(errorr)
				sendMessage(user: user, message: "there was an internal error, im sowwy")
			}
		}
		
	}.resume()
}

func sendMessage(user: Int, message: String)
{
	let apiKey:String = ProcessInfo.processInfo.environment["BOT_KEY"] ?? "0"
	if apiKey == "0"
	{
		print("no key for bot")
		return
	}
	var strUrl = "https://api.telegram.org/bot%@/sendMessage?chat_id=%@&text=%@"
	strUrl = String(format: strUrl, apiKey, String(user), message.encodeUrl)
	guard let url = URL(string: strUrl) else { return }
	URLSession.shared.dataTask(with: url) { (data, response, error) in
		print("tried to say "+message)
	}.resume()
	
}

func getUpdate() {
	UserDefaults.standard.set(false, forKey: "canUpdate")
	let apiKey:String = ProcessInfo.processInfo.environment["BOT_KEY"] ?? "0"
	if apiKey == "0"
	{
		print("no key for bot")
		return
	}
	let lastAnswerede = UserDefaults.standard.object(forKey: "lastAnswered")
	let jsonURLString = "https://api.telegram.org/bot"+String(apiKey)+"/getUpdates?offset="+String((lastAnswerede as! Int) + 1)
	guard let url = URL(string: jsonURLString) else { return }
	URLSession.shared.dataTask(with: url) { (data, response, error) in //Стартуем сессию подключения к ссылке API
		if error != nil {
			print(error!.localizedDescription) // если в ошибке что-то есть, то надо бы вывести эту ошибочку
		}
		guard let data = data else { return } // если в дате что-то есть, то кайфуем
		do {

			let botUpdate = try JSONDecoder().decode(BotUpdate.self, from: data)
			
			for result in botUpdate.result
			{
				let message = result.message ?? result.editedMessage
				if (message == nil)
				{
					continue
				}
				GetWeather(user: message!.from.id, CityID: message!.text)
				UserDefaults.standard.set(result.updateID, forKey: "lastAnswered")
			
			}
			UserDefaults.standard.set(true, forKey: "canUpdate")
		} catch {
			print("was error")
			print("Unexpected error: \(error).")
		}
		
	}.resume()
}
