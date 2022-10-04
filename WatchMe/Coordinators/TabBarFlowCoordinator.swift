//
//  TabBarFlowCoordinator.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

enum TabBarPage {
    case randomizer
    case search
    
    init?(index: Int) {
        switch index {
        case 0:  self = .randomizer
        case 1:  self = .search
        default: return nil
        }
    }
    
    func titleSelection() -> String {
        switch self {
        case .randomizer: return "Рандомайзер"
        case .search:   return "Поиск"
        }
    }
    
    func screenSelection() -> Int {
        switch self {
        case .randomizer: return 0
        case .search:   return 1
        }
    }
    
    func imageSelection() -> UIImage? {
        switch self {
        case .randomizer: return UIImage(systemName: "play.rectangle.on.rectangle")
        case .search:   return UIImage(systemName: "magnifyingglass")
        }
    }
}

final class TabBarFlowCoordinator: NSObject, Coordinator {
    
    var childDependencies: CoordinatorDependencies
    weak var flowListener: CoordinatorFlowListener?
    weak var navigationController: UINavigationController?
    
    private var tabBarController: UITabBarController
    private var moviesFlowCoordinator: Coordinator?
    private var movieSearchFlowCoordinator: Coordinator?
            
    init(navigationController: UINavigationController?,
         flowListener: CoordinatorFlowListener?,
         childDependencies: CoordinatorDependencies = DefaultCoordinatorDepencies()) {
        self.navigationController = navigationController
        self.flowListener = flowListener
        self.childDependencies = childDependencies
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarPage] = [.search, .randomizer]
            .sorted(by: { $0.screenSelection() < $1.screenSelection() })
        
        let controllers = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.randomizer.screenSelection()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .systemBackground
        
        navigationController?.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        
        let navigationController = UINavigationController()
        
        navigationController.setNavigationBarHidden(false, animated: false)
        
        navigationController.tabBarItem = UITabBarItem(title: page.titleSelection(),
                                                image: page.imageSelection(),
                                                tag: page.screenSelection())
        
        switch page {
        case .randomizer:
            let movieVC = RandomizerFlowCoordinator(navigationController: navigationController,
                                                flowListener: flowListener)
            moviesFlowCoordinator = movieVC
            movieVC.start()
        case .search:
            let movieSearchVC = MovieSearchFlowCoordinator(navigationController: navigationController,
                                                           flowListener: flowListener)
            movieSearchFlowCoordinator = movieSearchVC
            movieSearchVC.start()
        }
        
        return navigationController
    }
}
