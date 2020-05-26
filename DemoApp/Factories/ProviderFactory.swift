//
//  ProviderFactory.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit
import CoreData

protocol IProviderFactory {
    func getOrCreateDataProvider(context: NSManagedObjectContext) -> IListItemDataProvider
}

class ProviderFactory: IFactory {
    fileprivate var providers: [String: IProvider] = [:]
}

// MARK: - IProviderFactory

extension ProviderFactory: IProviderFactory {
    func getOrCreateDataProvider(context: NSManagedObjectContext) -> IListItemDataProvider {
        let key = String(describing: IListItemDataProvider.self)
        var provider = providers[key]
        if provider == nil {
            provider = ListItemDataProvider(context: context)
            providers[key] = provider
        }
        return provider as! IListItemDataProvider
    }
}
