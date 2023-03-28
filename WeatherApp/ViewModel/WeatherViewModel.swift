//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Prateek on 28/03/23.
//

import Foundation

class WeatherViewModel {
    
    var remoteWeather: RemoteWeatherLoader?
    var weatherData: WeatherData?
    
    var url = URL(string: Constant.url)!
    
    var onGetResponse: (([Weather]) -> Void)?
    
    var onGetError: ((Error) -> Void)?
    
    var city: String? {
        return weatherData?.name
    }
    
    func loadWeatherData(for city: String) {
        let queryItems = [URLQueryItem(name: "q", value: city), URLQueryItem(name: "appid", value: Constant.apiKey)]
        url.append(queryItems: queryItems)
        let session = URLSession(configuration: .ephemeral)
        
        let client = URLSessionHTTPClient(session)
        
        remoteWeather = RemoteWeatherLoader(url: url, client: client)
        
        remoteWeather?.load {[weak self] result in
            switch result {
            case let .success(weather):
                self?.weatherData = weather
                self?.onGetResponse?(weather.weather)
            case let .failure(error):
                self?.onGetError?(error)
            }
        }
    }
    
}
