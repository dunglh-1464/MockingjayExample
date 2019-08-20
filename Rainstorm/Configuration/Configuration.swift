//
//  Configuration.swift
//  Rainstorm
//
//  Created by Bart Jacobs on 14/06/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import Foundation

enum Defaults {
    
    static let location = Location(latitude: 37.335114, longitude: -122.008928)
    
}

enum Configuration {
    
    static var refreshThreshold: TimeInterval {
        #if DEBUG
        return 60.0
        #else
        return 10.0 * 60.0
        #endif
    }
    
}

enum WeatherService {
    
    private static let apiKey = "65c7493678085c128c8148bb39157b47"
    private static let baseUrl = URL(string: "https://api.darksky.net/forecast/")!
    
    static var authenticatedBaseUrl: URL {
        return baseUrl.appendingPathComponent(apiKey)
    }
    
}
