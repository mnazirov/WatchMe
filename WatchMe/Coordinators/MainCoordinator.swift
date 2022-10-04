//
//  MainCoordinator.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

protocol Coordinator: AnyObject {
    var childDependencies: CoordinatorDependencies { get }
    var navigationController: UINavigationController? { get set }
    func start()
}

protocol CoordinatorFlowListener: AnyObject {
    func onFlowFinished(coordinator: Coordinator)
}

final class MainCoordinator: Coordinator {
    
    var childDependencies: CoordinatorDependencies
    weak var navigationController: UINavigationController?
            
    init(navigationController: UINavigationController,
         childDependencies: CoordinatorDependencies = DefaultCoordinatorDepencies()) {
        self.navigationController = navigationController
        self.childDependencies = childDependencies
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        let tabBarCoordinator = TabBarFlowCoordinator(
            navigationController: self.navigationController,
            flowListener: self
        )
        self.childDependencies.addCoordinator(dependency: tabBarCoordinator)
        tabBarCoordinator.start()
    }
}

// MARK: - CoordinatorFlowListener
extension MainCoordinator: CoordinatorFlowListener {
    func onFlowFinished(coordinator: Coordinator) {
        childDependencies.removeCoordinator(dependency: coordinator)
        start()
    }
}
