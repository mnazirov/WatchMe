//
//  Movie.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

struct Movie: Codable, Equatable {
    var image: Data?
    let name: String
    var description: String?
    let date: Date?
    let trailer: String?
    let rating: Float
}
