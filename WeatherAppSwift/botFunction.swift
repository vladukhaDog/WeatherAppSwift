//
//  botFunction.swift
//  WeatherAppSwift
//
//  Created by vladukha on 06.12.2020.
//
//https://api.telegram.org/bot1444330618:AAHIEl4Tv68kh1tXc5BmL7MClmd7jv5ot14/sendMessage?chat_id=445668313&text=retard
//https://api.telegram.org/bot1444330618:AAHIEl4Tv68kh1tXc5BmL7MClmd7jv5ot14/getUpdates?offset=347648859
import Foundation
var lastMessage: [Int: Int] = [:]

func sendMessage(user: Int, message: String)
{
	let apiKey:String = ProcessInfo.processInfo.environment["BOT_KEY"] ?? "0"
	if apiKey == "0"
	{
		print("no key for bot")
	}
	else
	{
		let jsonURLString = "https://api.telegram.org/bot"+String(apiKey)+"/sendMessage?chat_id="+String(user)+"&text="+message
		guard let url = URL(string: jsonURLString) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			print("tried to say "+message)
		}.resume()
	}
}

func getUpdate() {
	UserDefaults.standard.set(false, forKey: "canUpdate")
	let apiKey:String = ProcessInfo.processInfo.environment["BOT_KEY"] ?? "0"
	if apiKey == "0"
	{
		print("no key for bot")
	}
	else
	{
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
				print("-----MESSAGE-------")
				print(result.message.text)
				sendMessage(user: result.message.from.id, message: result.message.text)
				//print("said "+result.message.text)
				UserDefaults.standard.set(result.updateID, forKey: "lastAnswered")
			
			}
			UserDefaults.standard.set(true, forKey: "canUpdate")
			//print(botUpdate)
		} catch {
			print("was error")
		}
		
	}.resume()}
}
