//
//  CDViewModel.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

struct CDViewModel {
    let title: String
    let artist: String
    let country: String
    let company: String
    let price: String
    let year: String

    init(cd: CD) {
        title = cd.title
        artist = cd.artist
        country = cd.country
        company = cd.company
        price = cd.price
        year = cd.year
    }
}
