//
//  UIViewController+Extensions.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

extension UIViewController {
    // from https://stackoverflow.com/a/2777460
    func isVisible() -> Bool {
        return viewIfLoaded?.window != nil
    }
}
