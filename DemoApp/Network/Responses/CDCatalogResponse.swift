//
//  CDCatalogResponse.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

struct CDCatalogResponse: INetworkResponse {
    var data: Data

    init(data: Data) {
        self.data = data
    }
}
