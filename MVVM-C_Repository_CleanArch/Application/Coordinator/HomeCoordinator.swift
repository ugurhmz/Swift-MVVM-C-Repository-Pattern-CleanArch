//
//  HomeCoordinator.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import UIKit

@MainActor
final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController()
        navigationController.pushViewController(homeVC, animated: true)
    }
}
