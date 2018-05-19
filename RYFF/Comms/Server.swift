//
//  Server.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation

class Server {
	static let instance = Server()
	
	
}


extension Server {
	static let apiVersion = "2.0"
//	static let baseURL = URL(string: "https://sportform.ca/c/ryff/webservice/division_teams.json.php?ver=2.0")!
	static let baseURL = URL(string: "https://sportform.ca/c/ryff/webservice")!

	func buildURL(for endpoint: String, _ additionalQueryItems: [String: String] = [:]) -> URL {
		var components = URLComponents(url: Server.baseURL, resolvingAgainstBaseURL: true)!
		components.path = components.path + "/" + endpoint + ".json.php"
		var queryItems = components.queryItems ?? []
		queryItems.append(URLQueryItem(name: "ver", value: Server.apiVersion))
		
		for (key, value) in additionalQueryItems {
			queryItems.append(URLQueryItem(name: key, value: value))
		}

		components.queryItems = queryItems
		return components.url!
	}
}
