//
//  UIViewController+Storyboard.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

enum Storyboard: String {
    typealias RawValue = String

    case main = "Main"
}

extension UIViewController {
    static func fromStoryboard(_ storyboard: Storyboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil),
                                                 identifier: identifier)
    }
}

private extension UIViewController {
    static func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard,
                                                                       identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
