//
//  EndPointType.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

protocol EndPointType {
    var baseURL: URL            { get }
    var path: String            { get }
    var httpMethod: HTTPMethod  { get }
    var task: HTTPTask          { get }
    var headers: HTTPHeaders?   { get }
}
