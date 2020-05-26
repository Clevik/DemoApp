//
//  String+Localization.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

// from https://gist.github.com/Juanpe/0ba09355229c0afa2ced6609735fd46c
// How to use
// "hello".localized
// "hello %@! you are %d years old".localized(args: ["Mike", 25])
// "hello %@! you are %d years old".localized("Mike", 25)
extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "\(self)_comment")
  }

  func localized(args: [CVarArg]) -> String {
    return localized(args)
  }

  func localized(_ args: CVarArg...) -> String {
    return String(format: localized, args)
  }
}
