//
//  HTTPTask.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
}
