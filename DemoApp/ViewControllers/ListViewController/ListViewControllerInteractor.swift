//
//  ListViewControllerInteractor.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation

protocol IListViewControllerInteractor {
    func deleteViewModel(_ viewModel: ListViewModel?)
    func editViewModel(_ viewModel: ListViewModel?)
    func loadSavedData()
    func toggle(viewModel: ListViewModel)
}

class ListViewControllerInteractor {
    private var presenter: IListViewControllerPresenter
    private var dataProvider: IListItemDataProvider
    
    init(presenter: IListViewControllerPresenter,
         dataProvider: IListItemDataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
        self.dataProvider.onUpdate = { [weak self] item in
            self?.presenter.update(item: item)
        }
        self.dataProvider.onInsert = { [weak self] item in
            self?.presenter.add(item: item)
        }
        self.dataProvider.onDelete = { [weak self] item in
            self?.presenter.delete(item: item)
        }
    }
}

// MARK: - IListViewControllerInteractor

extension ListViewControllerInteractor: IListViewControllerInteractor {
    func loadSavedData() {
        presenter.updateAllItems(dataProvider.savedItems())
    }
    
    func deleteViewModel(_ viewModel: ListViewModel?) {
        guard let viewModel = viewModel else { return }
        dataProvider.delete(itemId: viewModel.id)
    }
    
    func editViewModel(_ viewModel: ListViewModel?) {
        presenter.editViewModel(viewModel)
    }
    
    func toggle(viewModel: ListViewModel) {
        dataProvider.update(itemId: viewModel.id,
                            title: viewModel.titleString,
                            isOn: !viewModel.isOn)
    }
}
