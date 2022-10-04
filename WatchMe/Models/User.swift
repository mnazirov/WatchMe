//
//  File.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

struct User: Codable, Equatable {
    let name: String?
    let email: String
    let password: String
    var movies: [Movie]?
}
