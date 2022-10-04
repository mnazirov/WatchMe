//
//  CoordinatorDependencies.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

protocol CoordinatorDependencies {
    func addCoordinator(dependency coordinator: Coordinator)
    func removeCoordinator(dependency coordinator: Coordinator)
}

final class DefaultCoordinatorDepencies: CoordinatorDependencies {
    
    private var coordinators = [Coordinator]()
    
    func addCoordinator(dependency coordinator: Coordinator) {
        coordinators.append(coordinator)
    }
    
    func removeCoordinator(dependency coordinator: Coordinator) {
        coordinators.removeAll(where: { $0 === coordinator } )
    }
    
    
}
