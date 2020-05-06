//
//  Service.swift
//  App Store
//
//  Created by Nurtugan Nuraly on 5/6/20.
//  Copyright © 2020 XFamily LLC. All rights reserved.
//

import Foundation

final class Service {
    static let shared = Service() // Singleton
    
    private init() {}
    
    func fetchApps(completion: @escaping ([Result], Error?) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            if let err = err {
                print("Failed to fetch app: ", err)
                completion([], err)
                assertionFailure()
                return
            }
            
            guard let data = data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch {
                print(error)
                completion([], error)
            }
            
        }.resume()
        
    }
}
