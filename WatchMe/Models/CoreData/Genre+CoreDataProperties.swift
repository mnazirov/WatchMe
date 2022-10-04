//
//  Genre+CoreDataProperties.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var genre: String?

}

extension Genre : Identifiable {

}
