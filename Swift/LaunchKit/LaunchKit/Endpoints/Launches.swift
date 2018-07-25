//
//  Launches.swift
//  LaunchKit
//
//  Created by Brett Ohland on 7/24/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

extension LaunchKit {
    
    public struct API {
        
        public static let session: URLSession = URLSession(configuration: .default)
        static var task: URLSessionDataTask?
        
        enum APIError: Error {
            case url
            case unknown
        }
        
        struct Constants {
            static let mainURL = "https://launchlibrary.net"
            static let version = "1.4"
            static let baseURL = "\(Constants.mainURL)/\(Constants.version)"
        }
        
        enum Endpoint {
            case nextLaunches(number: Int)
            case launchDetails(number: Int)
            
            func url() -> URL? {
                switch self {
                case .nextLaunches(let numberOfLaunches):
                    // https://launchlibrary.net/1.4/launch/next/5
                    return URL(string: "\(Constants.baseURL)/launch/next/\(numberOfLaunches)")
                case .launchDetails(let launchNumber):
                    // https://launchlibrary.net/1.4/launch/120
                    return URL(string:"\(Constants.baseURL)/launch/\(launchNumber)")
                }
            }
        }
        
    }
    
}

public extension LaunchKit.API {
    
    static func getLaunches(_ completion: @escaping ([LaunchKit.Launch], Error?) -> Void, session: URLSession = session) {
        
        LaunchKit.API.task?.cancel()
        
        guard let url = Endpoint.nextLaunches(number: 10).url() else {
            completion([], APIError.url)
            return
        }
        
        LaunchKit.API.task = session.dataTask(with: url) { (data, response, error) in
            
            switch (data, response, error) {
                
            case (_, _, .some(let error)):
                completion([], error)
                
            case (.some(let data), .some(let response), _ ):
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion([], APIError.unknown)
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    
                    do {
                        let decoder = JSONDecoder()
                        let rawLaunches = try decoder.decode(RawResponses.Launch.self, from: data)
                        completion(rawLaunches.launches, error)
                    } catch {
                        completion([], error)
                    }
                    
                default:
                    completion([], error)
                }
                
            default:
                completion([], error)
            }
            
        }
        
        LaunchKit.API.task?.resume()
        
    }
    
}
