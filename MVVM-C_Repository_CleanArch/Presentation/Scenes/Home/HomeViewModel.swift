//
//  HomeViewModel.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    private let repository: CharacterRepositoryProtocol
    private(set) var characters: [Character] = []
    
    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        delegate?.didChangeState(state: .loading)
        
        Task {
            let result = await repository.fetchCharacters()
            switch result {
            case .success(let charactersData):
                self.characters = charactersData
                delegate?.didChangeState(state: .success)
                
            case .failure(let error):
                delegate?.didChangeState(state: .failure(error.localizedDescription))
            }
        }
    }
}
