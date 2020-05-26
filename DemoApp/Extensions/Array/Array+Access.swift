//
//  Array+Access.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

extension Array {
    func safeItem(at: Int) -> Element? {
        if at < 0 || at >= self.count {
            return nil
        }

        return self[at]
    }
}
