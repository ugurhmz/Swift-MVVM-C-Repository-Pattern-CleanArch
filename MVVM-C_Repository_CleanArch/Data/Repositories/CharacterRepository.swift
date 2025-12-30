//
//  CharacterRepository.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation

final class CharacterRepository: CharacterRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCharacters() async -> Result<[Character], any Error> {
        let endPoint = RickAndMortyEndpoint.characters
        
        let result = await networkService.request(endPoint, type: RickAndMortyResponse.self)
        
        switch result {
        case .success(let response):
            let entities = response.results.map { $0.toDomain }
            return .success(entities)
        case .failure(let error):
            return .failure(error)
        }
    }
}
