//
//  Factory.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

protocol IFactory {
}

protocol IFactoryContainer: IFactory {
    func getOrCreateNetworkFactory() -> INetworkFactory
    func getOrCreateViewControllerFactory() -> IViewControllerFactory
    func getOrCreateProviderFactory() -> IProviderFactory
}

class Factory: IFactory {
    fileprivate var factories: [String: IFactory] = [:]
}

// MARK: - IFactoryContainer

extension Factory: IFactoryContainer {
    func getOrCreateNetworkFactory() -> INetworkFactory {
        let key = String(describing: INetworkFactory.self)
        var factory = factories[key]
        if factory == nil {
            factory = NetworkFactory()
            factories[key] = factory
        }
        return factory as! INetworkFactory
    }
    
    func getOrCreateViewControllerFactory() -> IViewControllerFactory {
        let key = String(describing: IViewControllerFactory.self)
        var factory = factories[key]
        if factory == nil {
            factory = ViewControllerFactory(factoryContainer: self)
            factories[key] = factory
        }
        return factory as! IViewControllerFactory
    }
    
    func getOrCreateProviderFactory() -> IProviderFactory {
        let key = String(describing: IProviderFactory.self)
        var factory = factories[key]
        if factory == nil {
            factory = ProviderFactory()
            factories[key] = factory
        }
        return factory as! IProviderFactory
    }
}
