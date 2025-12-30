//
//  CharacterRepositoryProtocol.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation

@MainActor
protocol CharacterRepositoryProtocol: Sendable {
    func fetchCharacters() async -> Result<[Character], Error>
}
