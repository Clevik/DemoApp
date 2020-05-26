//
//  NetworkFactory.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol INetworkFactory: IFactory {
    func createNetwork() -> INetwork
    func createCDCatalogRequest<T: INetworkRequest>() -> T
}

class NetworkFactory: IFactory {
    required init() {}
}

// MARK: - INetworkFactory

extension NetworkFactory: INetworkFactory {
    func createNetwork() -> INetwork {
        return Network()
    }

    func createCDCatalogRequest<T: INetworkRequest>() -> T {
        return CDCatalogRequest() as! T
    }
}
