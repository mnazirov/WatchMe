//
//  MoviesFlowCoordinator.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

protocol MoviesFlowCoordinatorHandler: AnyObject {
}

final class RandomizerFlowCoordinator: Coordinator {
    
    var childDependencies: CoordinatorDependencies
    weak var flowListener: CoordinatorFlowListener?
    weak var navigationController: UINavigationController?
    weak var favoriteMoviesViewController: RandomizerViewController?
        
    private let alertFactory = DefaultsAlertFactory()
    
    init(navigationController: UINavigationController?,
         flowListener: CoordinatorFlowListener?,
         childDependencies: CoordinatorDependencies = DefaultCoordinatorDepencies()) {
        self.navigationController = navigationController
        self.flowListener = flowListener
        self.childDependencies = childDependencies
    }
    
    func start() {
        let viewController = RandomizerViewController()
        favoriteMoviesViewController = viewController
        viewController.moviesCoordinatorHandler = self
        viewController.title = "Рандомайзер"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - MoviesFlowCoordinatorHandler
extension RandomizerFlowCoordinator: MoviesFlowCoordinatorHandler {

}
