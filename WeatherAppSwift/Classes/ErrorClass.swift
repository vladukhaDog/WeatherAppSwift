//
//  ErrorClass.swift
//  WeatherAppSwift
//
//  Created by vladukha on 01.12.2020.
//

import Foundation
//Класс для хранения ошибок от API
struct WeatherError: Hashable, Codable, Identifiable {
	let id: Int?
	let cod, message: String?
}
