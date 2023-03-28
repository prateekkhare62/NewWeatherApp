//
//  RemoteWeatherLoader.swift
//  WeatherApp
//
//  Created by Prateek on 27/03/23.
//

import Foundation

public final class RemoteWeatherLoader: WeatherService {

    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = WeatherService.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteWeatherLoader.map(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
    
    private static func map(_ data: Data, response: HTTPURLResponse) -> Result {
            guard response.statusCode == 200, let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                return .failure(Error.invalidData)
            }
            return .success(weatherData)
    }
    
}
