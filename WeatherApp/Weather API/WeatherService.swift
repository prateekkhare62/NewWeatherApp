//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Prateek on 25/01/21.
//

import Foundation

 public protocol WeatherService {
    
    typealias Result = Swift.Result<WeatherData, Error>
    
    func load(completion: @escaping(Result) -> Void)
}
