//
//  ViewController.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit

final class RandomizerViewController: UIViewController {
    
    weak var moviesCoordinatorHandler: RandomizerFlowCoordinator?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
}

// MARK: - Private methods
private extension RandomizerViewController {
    
    func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Layout.backgroundColor
        appearance.shadowColor = Layout.shadowColor
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.view.backgroundColor = Layout.backgroundColor
    }
}

// MARK: - Layout
private extension RandomizerViewController {
    enum Layout {
        static let estimatedRowHeight: CGFloat = 150
        static let backgroundColor: UIColor = .systemBackground
        static let shadowColor: UIColor = .clear
    }
}
