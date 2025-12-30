//
//  CoreNetworkAdapter.swift
//  MVVM-C_Repository_CleanArch
//
//  Created by rico on 30.12.2025.
//

import Foundation
import CoreNetworking

final class CoreNetworkAdapter: NetworkServiceProtocol {
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async -> Result<T, NetworkError> {
        return await client.request(endpoint, type: type)
    }
}
