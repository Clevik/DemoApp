//
//  ListItemViewControllerInteractor.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol IListItemViewControllerInteractor {
    func cancel()
    func loadItem(id: UUID?)
    func saveItem(id: UUID?, title: String?)
    func requestSaveItem(title: String?)
}

class ListItemViewControllerInteractor {
    private var presenter: IListItemViewControllerPresenter
    private var dataProvider: IListItemDataProvider
    
    init(presenter: IListItemViewControllerPresenter,
         dataProvider: IListItemDataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
    }
}

// MARK: - IListItemViewControllerInteractor

extension ListItemViewControllerInteractor: IListItemViewControllerInteractor  {
    func cancel() {
        presenter.close()
    }
    
    func requestSaveItem(title: String?) {
        guard let _ = title else {
            presenter.close()
            return
        }
        
        presenter.showAlert(title: "warning".localized,
                            text: "list_item_view_controller.alert.save_request".localized)
    }
    
    func loadItem(id: UUID?) {
        guard let id = id else {
            presenter.updateName("")
            return
        }
        
        if let item = dataProvider.itemWith(itemId: id) {
            presenter.updateName(item.title)
        }
    }
    
    func saveItem(id: UUID?, title: String?) {
        guard let title = title else {
            presenter.showAlert(title: "error".localized,
                                text: "list_item_view_controller.alert.empty_name_error".localized)
            return
        }
        
        if let id = id {
            dataProvider.update(itemId: id, title: title)
        } else {
            dataProvider.insert(title: title)
        }
        
        presenter.close()
    }
}
