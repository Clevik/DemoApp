//
//  ViewControllerFactory.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit
import CoreData

protocol IViewControllerFactory: IFactory {
    func createTabBarController() -> UITabBarController
    func createListViewController() -> IListViewController
    func createServiceViewController() -> IServiceViewController
    func createListItemViewController(itemID: UUID?) -> IListItemViewController
}

class ViewControllerFactory: IFactory {
    private var factoryContainer: IFactoryContainer
    
    init(factoryContainer: IFactoryContainer) {
        self.factoryContainer = factoryContainer
    }
}

// MARK: - IViewControllerFactory

extension ViewControllerFactory: IViewControllerFactory {
    func createListViewController() -> IListViewController {
        let presenter = ListViewControllerPresenter()
        let context = (UIApplication.shared.delegate as? AppDelegate)!.context
        let dataProvider = factoryContainer.getOrCreateProviderFactory().getOrCreateDataProvider(context: context)
        let interactor = ListViewControllerInteractor(presenter: presenter,
                                                      dataProvider: dataProvider)
        
        let viewController = ListViewController.create(viewControllerFactory: self,
                                                       interactor: interactor)
        presenter.resolveDependecies(viewController: viewController)
        return viewController
    }
    
    func createServiceViewController() -> IServiceViewController {
        let networkFactory = factoryContainer.getOrCreateNetworkFactory()
        let presenter = ServiceViewControllerPresenter()
        let interactor = ServiceViewControllerInteractor(networkFactory: networkFactory, presenter: presenter)
        let viewController = ServiceViewController.create(interactor: interactor)
        presenter.resolveDependecies(viewController: viewController)

        return viewController
    }
    
    func createTabBarController() -> UITabBarController {
        let listViewController = createListViewController().encapsulateInNavigationController()
        let serviceViewController = createServiceViewController().encapsulateInNavigationController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [listViewController, serviceViewController]
        tabBarController.tabBar.items?[0].image = UIImage(named: "list")
        tabBarController.tabBar.items?[1].image = UIImage(named: "download")
        return tabBarController
    }
    
    func createListItemViewController(itemID: UUID?) -> IListItemViewController {
        let presenter = ListItemViewControllerPresenter()
        let context = (UIApplication.shared.delegate as? AppDelegate)!.context
        let dataProvider = factoryContainer.getOrCreateProviderFactory().getOrCreateDataProvider(context: context)
        let interactor = ListItemViewControllerInteractor(presenter: presenter,
                                                          dataProvider: dataProvider)
        let viewController = ListItemViewController.create(itemID: itemID, interactor: interactor)
        presenter.resolveDependecies(viewController: viewController)

        return viewController
    }
}
