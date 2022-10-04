//
//  Country+CoreDataProperties.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var country: String?

}

extension Country : Identifiable {

}
