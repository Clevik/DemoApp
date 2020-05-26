//
//  UIViewController+UINavigationController.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

extension UIViewController {
    func encapsulateInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.title = self.title
        return navigationController
    }
}
