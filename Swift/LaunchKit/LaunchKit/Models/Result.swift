//
//  Result.swift
//  LaunchKit
//
//  Created by Brett Ohland on 7/24/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

public enum NetworkResult<T> {
    case failure(Error)
    case success(T)
}
