//
//  Character.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation

struct Character: Identifiable,Sendable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String
}
