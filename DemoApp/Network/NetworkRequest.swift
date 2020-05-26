//
//  NetworkRequest.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol INetworkRequest {
    associatedtype Response: INetworkResponse

    var url: URL { get }

    func response<Response>(data: Data) -> Response
    func execute(network: INetwork, _ completion: @escaping (Result<Response, Error>) -> Void)
}
