//
//  CDCatalogRequest.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

struct CDCatalogRequest: INetworkRequest {
    typealias Response = CDCatalogResponse

    var url: URL { URL(string: "https://www.w3schools.com/xml/cd_catalog.xml")! }

    func response<Response>(data: Data) -> Response {
        return CDCatalogResponse(data: data) as! Response
    }

    func execute(network: INetwork, _ completion: @escaping (Result<Response, Error>) -> Void) {
        network.executeRequest(self) { result in
            switch result {
            case .success(let response):
                completion(.success(response as! Response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
