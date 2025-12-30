//
//  RickAndMortyEndpoint.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation
import CoreNetworking

enum RickAndMortyEndpoint: Endpoint, Sendable {
    case characters
    
    var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/character"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var task: RequestTask {
        .requestPlain
    }
    
    var headers: [String : String]? {
        ["Content-Type" : "application/json"]
    }
}
