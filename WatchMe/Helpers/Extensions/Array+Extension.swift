//
//  Array+Extension.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
