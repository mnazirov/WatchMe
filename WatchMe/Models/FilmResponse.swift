//
//  Films.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

struct FilmApiResponse: Decodable {
    let pagesCount: Int
    let films: [FilmResponse]
}

struct DetailFilmApiResponse: Decodable {
    let kinopoiskId: Int
    let nameRu: String
    let nameOriginal: String?
    let year: Int
    let description: String?
    let filmLength: Int
    let countries: [CountryResponse]
    let genres: [GenreResponse]
    let ratingKinopoisk: Double?
    let ratingKinopoiskVoteCount: Int
    let posterUrl: String?
    let slogan: String?
    let webUrl: String?
}

struct FilmResponse: Decodable {
    let filmId: Int
    let nameRu: String
    let nameEn: String?
    let year: String
    let description: String?
    let filmLength: String?
    let countries: [CountryResponse]
    let genres: [GenreResponse]
    let rating: String?
    let ratingVoteCount: Int
    let posterUrl: String?
    let slogan: String?
    let webUrl: String?
}

struct CountryResponse: Decodable {
    let country: String
}

struct GenreResponse: Decodable {
    let genre: String
}
