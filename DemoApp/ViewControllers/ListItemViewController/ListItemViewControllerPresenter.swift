//
//  ListItemViewControllerPresenter.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol IListItemViewControllerPresenter {
    func close()
    func showAlert(title: String, text: String)
    func showError(title: String, text: String)
    func updateName(_ name: String?)
}

class ListItemViewControllerPresenter {
    private weak var viewController: IListItemViewController?

    func resolveDependecies(viewController: IListItemViewController) {
        self.viewController = viewController
    }
}

// MARK: - IListItemViewControllerPresenter

extension ListItemViewControllerPresenter: IListItemViewControllerPresenter {
    func close() {
        viewController?.close()
    }
    
    func showAlert(title: String, text: String) {
        viewController?.showAlert(title: title, text: text)
    }
    
    func showError(title: String, text: String) {
        viewController?.showError(title: title, text: text)
    }
    
    func updateName(_ name: String?) {
        viewController?.updateName(name ?? "")
    }
}
