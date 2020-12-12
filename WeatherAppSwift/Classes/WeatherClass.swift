//
//  WeatherClass.swift
//  WeatherAppSwift
//
//  Created by vladukha on 01.12.2020.
//

import Foundation

// MARK: - Weather
struct Weather: Hashable, Codable, Identifiable {
	let coord: Coord?
	let weather: [WeatherElement?]
	let base: String?
	let main: Main?
	let visibility: Int?
	let wind: Wind?
	let clouds: Clouds?
	let dt: Int?
	let sys: Sys?
	let timezone, id: Int?
	let name: String?
	let cod: Int?
}

// MARK: - Clouds
struct Clouds: Hashable, Codable{
	let all: Int?
}

// MARK: - Coord
struct Coord: Hashable, Codable {
	let lon, lat: Double?
}

// MARK: - Main
struct Main: Hashable, Codable {
	let temp, feelsLike, tempMin, tempMax: Double?
	let pressure, humidity: Int?

	enum CodingKeys: String, CodingKey {
		case temp
		case feelsLike = "feels_like"
		case tempMin = "temp_min"
		case tempMax = "temp_max"
		case pressure, humidity
	}
}

// MARK: - Sys
struct Sys: Hashable, Codable {
	let type, id: Int?
	let message: Double?
	let country: String?
	let sunrise, sunset: Int?
}

// MARK: - WeatherElement
struct WeatherElement: Hashable, Codable {
	let id: Int?
	let main, weatherDescription, icon: String?

	enum CodingKeys: String, CodingKey {
		case id, main
		case weatherDescription = "description"
		case icon
	}
}

// MARK: - Wind
struct Wind: Hashable, Codable {
	let speed: Double?
	let deg: Int?
}

