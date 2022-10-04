//
//  MovieSearchFlowCoordinator.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

protocol MovieSearchFlowCoordinatorHandler: AnyObject {
    func didPressOnCell(id: Int)    
    func showLoading()
    func dissmisLoading()
}

final class MovieSearchFlowCoordinator: Coordinator {
    
    var childDependencies: CoordinatorDependencies
    weak var navigationController: UINavigationController?
    weak var flowListener: CoordinatorFlowListener?
    
    private weak var movieSearchViewController: UIViewController?
    private lazy var loadingViewController = LoadingViewController()
    private let alertFactory = DefaultsAlertFactory()
    
    init(navigationController: UINavigationController?,
         flowListener: CoordinatorFlowListener?,
         childDependencies: CoordinatorDependencies = DefaultCoordinatorDepencies()) {
        self.navigationController = navigationController
        self.flowListener = flowListener
        self.childDependencies = childDependencies
    }
    
    func start() {
        let viewController = MovieSearchViewController()
        movieSearchViewController = viewController
        viewController.movieSearchCoordinatorHandler = self
        navigationController?.pushViewController(viewController, animated: true)
        showLoading()
    }
}


extension MovieSearchFlowCoordinator: MovieSearchFlowCoordinatorHandler {
    
    func didPressOnCell(id: Int) {
        let viewController = CategoryDetailMovieViewController(id: id)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showLoading() {
        loadingViewController.modalPresentationStyle = .overCurrentContext
        loadingViewController.modalTransitionStyle = .crossDissolve
        movieSearchViewController?.present(loadingViewController, animated: true, completion: nil)
    }
    
    func dissmisLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingViewController.dismiss(animated: true)
        }
    }
}
