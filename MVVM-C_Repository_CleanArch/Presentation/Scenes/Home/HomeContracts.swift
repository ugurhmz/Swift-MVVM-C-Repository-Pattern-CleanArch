//
//  HomeContracts.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation

enum HomeViewState {
    case loading
    case success
    case failure(String)
}

@MainActor
protocol HomeViewModelDelegate: AnyObject {
    func didChangeState(state: HomeViewState)
}


@MainActor
protocol HomeViewModelProtocol: AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    var characters: [Character] { get }
    
    func viewDidLoad()
}
