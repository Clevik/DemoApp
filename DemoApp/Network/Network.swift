//
//  Network.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case errorExecuteRequest
}

protocol INetwork {
    func executeRequest<T: INetworkRequest>(_ request: T, _ completion: @escaping (Result<INetworkResponse, Error>) -> Void)
}

class Network: INetwork {
    private let defaultSession = URLSession(configuration: .default)

    func executeRequest<T: INetworkRequest>(_ request: T, _ completion: @escaping (Result<INetworkResponse, Error>) -> Void) {
        let urlRequest = URLRequest(url: request.url)
        let task = defaultSession.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil || data == nil {
                completion(.failure(NetworkError.errorExecuteRequest))
            }

            let networkResponse: INetworkResponse = request.response(data: data!)
            completion(.success(networkResponse))
        }
        task.resume()
    }
}
