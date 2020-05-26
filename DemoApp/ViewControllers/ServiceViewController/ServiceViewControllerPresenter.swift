//
//  ServiceViewControllerPresenter.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol IServiceViewControllerPresenter {
    func finishParseCDElement(_ cd: CD)
}

class ServiceViewControllerPresenter {
    private weak var viewController: IServiceViewController?

    func resolveDependecies(viewController: IServiceViewController) {
        self.viewController = viewController
    }
}

// MARK: - IServiceViewControllerPresenter

extension ServiceViewControllerPresenter: IServiceViewControllerPresenter {
    func finishParseCDElement(_ cd: CD) {
        DispatchQueue.main.async { [weak self] in
            let cdViewModel = CDViewModel(cd: cd)
            self?.viewController?.addCDViewModel(cdViewModel)
        }
    }
}
