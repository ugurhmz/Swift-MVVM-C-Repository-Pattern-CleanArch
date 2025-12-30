//
//  HomeViewController.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not imp.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .lightGray
    }
    
    private func setupBinding() {
        viewModel.delegate = self
    }
}

// MARK: -
extension HomeViewController: HomeViewModelDelegate {
    func didChangeState(state: HomeViewState) {
        switch state {
        case .loading:
            print("LOADING > > > >> >")
        case .success:
            print("OK DATA: \(viewModel.characters)")
        case .failure(let msg):
            print("Oops ERR: \(msg)")
        }
    }
    
    
}
