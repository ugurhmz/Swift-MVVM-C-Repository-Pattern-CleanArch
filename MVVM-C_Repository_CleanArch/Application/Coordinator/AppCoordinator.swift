//
//  AppCoordinator.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let window: UIWindow
    
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        print("AppCoordinator starting..")
        startHomeFlow()
    }
}

// MARK: -
extension AppCoordinator {
    private func startHomeFlow() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
