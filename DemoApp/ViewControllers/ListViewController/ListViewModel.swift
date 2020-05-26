//
//  ListViewModel.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

struct ListViewModel {
    let imageName: String
    let id: UUID
    let titleString: String
    let isOn: Bool
    
    init(withListItem listItem: ListItem) {
        self.id = listItem.id ?? UUID()
        self.titleString = listItem.title ?? ""
        self.isOn = listItem.isOn
        self.imageName = self.isOn ? "ipod-classic" : "ipod-touch"
    }
}
