//
//  Film+CoreDataProperties.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var filmId: Int32
    @NSManaged public var filmLength: String?
    @NSManaged public var nameEn: String?
    @NSManaged public var nameRu: String?
    @NSManaged public var posterUrl: String?
    @NSManaged public var rating: String?
    @NSManaged public var ratingVoteCount: Int32
    @NSManaged public var year: String
    @NSManaged public var countries: NSSet?
    @NSManaged public var genres: NSSet?

}

// MARK: Generated accessors for countries
extension Film {

    @objc(addCountriesObject:)
    @NSManaged public func addToCountries(_ value: Country)

    @objc(removeCountriesObject:)
    @NSManaged public func removeFromCountries(_ value: Country)

    @objc(addCountries:)
    @NSManaged public func addToCountries(_ values: NSSet)

    @objc(removeCountries:)
    @NSManaged public func removeFromCountries(_ values: NSSet)

}

// MARK: Generated accessors for genres
extension Film {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: Genre)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: Genre)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}

extension Film : Identifiable {

}
