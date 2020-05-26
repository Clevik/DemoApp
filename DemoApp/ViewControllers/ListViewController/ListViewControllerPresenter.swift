//
//  ListViewControllerPresenter.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol IListViewControllerPresenter {
    func add(item: ListItem)
    func delete(item: ListItem)
    func update(item: ListItem)
    func updateAllItems(_ listItems: [ListItem]?)
    func editViewModel(_ viewModel: ListViewModel?)
}

class ListViewControllerPresenter {
    private weak var viewController: IListViewController?
    
    func resolveDependecies(viewController: IListViewController) {
        self.viewController = viewController
    }
}

// MARK: - IListViewControllerPresenter

extension ListViewControllerPresenter: IListViewControllerPresenter {
    func add(item: ListItem) {
        viewController?.addViewModel(ListViewModel(withListItem: item))
    }
    
    func delete(item: ListItem) {
        viewController?.deleteViewModel(ListViewModel(withListItem: item))
    }
    
    func update(item: ListItem) {
        viewController?.updateViewModel(ListViewModel(withListItem: item))
    }
    
    func updateAllItems(_ listItems: [ListItem]?) {
        let viewModels = listItems?.map{ ListViewModel(withListItem: $0) }
        viewController?.updateAllItems(viewModels)
    }
    
    func editViewModel(_ viewModel: ListViewModel?) {
        viewController?.opedEditor(itemID: viewModel?.id)
    }
}
