//
//  botUpdate.swift
//  WeatherAppSwift
//
//  Created by vladukha on 05.12.2020.
//

import Foundation

// MARK: - BotUpdate
struct BotUpdate: Codable {
	let ok: Bool
	let result: [Result]
}

// MARK: - Result
struct Result: Codable {
	let updateID: Int
	let message: Message?
	let editedMessage: Message?

	enum CodingKeys: String, CodingKey {
		case updateID = "update_id"
		case editedMessage = "edited_message"
		case message
	}
}

// MARK: - Message
struct Message: Codable {
	let messageID: Int
	let from: From
	let chat: Chat
	let date: Int
	let text: String

	enum CodingKeys: String, CodingKey {
		case messageID = "message_id"
		case from, chat, date, text
	}
}

// MARK: - Chat
struct Chat: Codable {
	let id: Int
	let firstName, username, type: String

	enum CodingKeys: String, CodingKey {
		case id
		case firstName = "first_name"
		case username, type
	}
}

// MARK: - From
struct From: Codable {
	let id: Int
	let isBot: Bool
	let firstName, username, languageCode: String

	enum CodingKeys: String, CodingKey {
		case id
		case isBot = "is_bot"
		case firstName = "first_name"
		case username
		case languageCode = "language_code"
	}
}
