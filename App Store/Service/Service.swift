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
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
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
    
    func fetchGames(compltion: @escaping (AppGroup?, Error?) -> Void) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json") else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                compltion(nil, err)
                return
            }
            guard let data = data else { return }
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                print(appGroup.feed.results)
                compltion(appGroup, nil)
            } catch {
                compltion(nil, error)
            }
        }.resume()
    }
    
}
