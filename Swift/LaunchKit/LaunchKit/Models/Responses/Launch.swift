//
//  Launch.swift
//  LaunchKit
//
//  Created by Brett Ohland on 7/24/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

struct RawResponses: Codable, Equatable {
    
    struct Launch: Codable, Equatable {
        let launches: [LaunchKit.Launch]
    }
    
}

public extension LaunchKit {
    
    struct Launch: Codable, Equatable {
        public let id: Int
        public let name: String
        public let windowstart: String
        public let windowend: String
        public let net: String
        public let rocket: Rocket
        public let missions: [Mission]
    }
    
    struct Rocket: Codable, Equatable {
        public let id: Int
        public let name: String
        public let configuration: String
        public let familyname: String
    }
    
    struct Mission: Codable, Equatable {
        public let id: Int
        public let name: String
        public let description: String
        public  let typeName: String
    }
    
}
