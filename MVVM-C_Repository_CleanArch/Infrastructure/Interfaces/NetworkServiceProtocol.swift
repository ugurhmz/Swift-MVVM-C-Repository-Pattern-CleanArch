//
//  NetworkServiceProtocol.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation
import CoreNetworking

protocol NetworkServiceProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async -> Result<T, NetworkError>
}
