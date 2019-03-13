//
//  StringExtension.swift
//  WeatherMap
//
//  Created by Esteban Ordonez on 3/13/19.
//  Copyright © 2019 Esteban Ordonez. All rights reserved.
//

import Foundation;

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        guard var components: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            fatalError("could not create URLComponents for URL \(self)");
        }
        components.queryItems = queries.map {URLQueryItem(name: $0.key, value: $0.value)}
        return components.url;
    }
}
