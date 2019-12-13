//
//  Launches.swift
//  LaunchKit
//
//  Created by Brett Ohland on 7/24/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

import Foundation

extension LaunchKit {
    public enum API {
        public static let session = URLSession(configuration: .default)
        static var task: URLSessionDataTask?

        enum APIError: Error {
            case url
            case unknown
        }

        enum Constants {
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
                    return URL(string: "\(Constants.baseURL)/launch/\(launchNumber)")
                }
            }
        }
    }
}

extension URLSession {
    func dataTask(
        with endpoint: LaunchKit.API.Endpoint,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask? {
        guard let url = endpoint.url() else {
            return nil
        }
        return self.dataTask(with: url, completionHandler: completionHandler)
    }
}

extension LaunchKit.API {
    static func decode<T: Decodable>(data: Data) -> Result<T, Error> {
        do {
            let decoder = JSONDecoder()
            let payload = try decoder.decode(T.self, from: data)
            return .success(payload)
        } catch {
            return .failure(error)
        }
    }

    public static func getLaunches(
        numberOfLaunches: Int,
        _ completion: @escaping (Result<[LaunchKit.Launch], Error>) -> Void,
        session: URLSession = session
    ) {
        let networkCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in

            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.unknown))
                return
            }

            switch (data, urlResponse.statusCode, error) {
            case (.some(let data), 200, _):
                let decodeResult: Result<RawResponses.Launch, Error> = LaunchKit.API.decode(data: data)
                switch decodeResult {
                case .success(let payload):
                    completion(.success(payload.launches))
                case .failure(let error):
                    completion(.failure(error))
                }

            default:
                completion(.failure(error ?? APIError.unknown))
            }
        }

        guard
            let dataTask = session.dataTask(
                with: .nextLaunches(number: numberOfLaunches),
                completionHandler: networkCompletionHandler
            )
        else {
            return completion(.failure(APIError.url))
        }
        LaunchKit.API.task = dataTask
        LaunchKit.API.task?.resume()
    }
}
