//
//  HomeCoordinator.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import UIKit
import CoreNetworking

@MainActor
final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let client = NetworkClient()
        let networkAdapter = CoreNetworkAdapter(client: client)
        let repository = CharacterRepository(networkService: networkAdapter)
        let viewModel = HomeViewModel(repository: repository)
        let homeVC = HomeViewController(viewModel: viewModel)
        
        navigationController.pushViewController(homeVC, animated: true)
    }
}
