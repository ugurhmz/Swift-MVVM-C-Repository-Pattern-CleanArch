//
//  RickAndMortyResponse.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation

struct RickAndMortyResponse: Decodable, Sendable {
    let results: [CharacterResponseModel]
    
}

struct CharacterResponseModel: Decodable, Sendable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let image: String?
    
    var toDomain: Character {
        return Character(id: id ?? 0,
                         name: name ?? "-",
                         status: status ?? "-",
                         species: species ?? "-",
                         image: image ?? "",)
    }
}
