//
//  WebserviceManager.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 29/05/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import Foundation

struct WebserviceManager {
    static let shared = WebserviceManager()
    
    func fetch(playerName: String?, completionHandler: @escaping ProfileCompletion) {
        do {
            var components = URLComponents(string: Constants.runemetricsAPI)
            components?.queryItems = [URLQueryItem(name: "user", value: playerName)]
            
            guard let url = components?.url else {
                throw NSError(domain: "Unable to generate URL from URLComponents", code: 418)
            }
            
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                        throw NSError(domain: "HTTP request returned error", code: 400)
                    }
                    
                    guard 200 ... 299 ~= response.statusCode else {
                        throw NSError(domain: "HTTP request did not receive successful HTTPURLResponse status code", code: response.statusCode)
                    }
                    
                    let profile = try JSONDecoder().decode(RunemetricsProfile.self, from: data)
                    profile.skills.sort { $0.id < $1.id }
                    
                    DispatchQueue.main.async {
                        completionHandler(profile)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                }
            }
            
            dataTask.resume()
        } catch {
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}
