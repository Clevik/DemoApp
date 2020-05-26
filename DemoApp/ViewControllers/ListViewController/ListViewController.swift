//
//  ListViewController.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

protocol IListViewController: UIViewController {
    func addViewModel(_ viewModel: ListViewModel)
    func deleteViewModel(_ viewModel: ListViewModel)
    func updateViewModel(_ viewModel: ListViewModel)
    func updateAllItems(_ viewModels: [ListViewModel]?)
    func opedEditor(itemID: UUID?)
}

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewControllerFactory: IViewControllerFactory?
    private var interactor: IListViewControllerInteractor?
    
    private var viewModels: [ListViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListTableViewCell.registerNib(for: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTouchUpInside(_:)))
        
        interactor?.loadSavedData()
    }
    
    class func create(viewControllerFactory: IViewControllerFactory?,
                      interactor: IListViewControllerInteractor?) -> ListViewController {
        let viewController = self.fromStoryboard(.main, identifier: nameOfClass())
        viewController.title = "list_view_controller.title".localized
        viewController.viewControllerFactory = viewControllerFactory
        viewController.interactor = interactor
        return viewController
    }
}

// MARK: - Private

private extension ListViewController {
    func tryAddViewModel(_ viewModel: ListViewModel) -> Int {
        viewModels.append(viewModel)
        return viewModels.count - 1
    }
    
    func tryDeleteViewModel(_ viewModel: ListViewModel) -> Int? {
        if let row = viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            viewModels.remove(at: row)
            return row
        }
        return nil
    }
    
    func tryUpdateViewModel(_ viewModel: ListViewModel) -> Int? {
        if let row = viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            viewModels[row] = viewModel
            return row
        }
        return nil
    }
}

// MARK: - IBAction
private extension ListViewController {
    @IBAction func addButtonTouchUpInside(_ sender: Any) {
        interactor?.editViewModel(nil)
    }
}

// MARK: - IListViewController

extension ListViewController: IListViewController {
    func addViewModel(_ viewModel: ListViewModel) {
        let row = tryAddViewModel(viewModel)
        if isVisible() {
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .right)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    func deleteViewModel(_ viewModel: ListViewModel) {
        guard let row = tryDeleteViewModel(viewModel) else { return }
        if isVisible() {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .left)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    func updateViewModel(_ viewModel: ListViewModel) {
        guard let row = tryUpdateViewModel(viewModel) else { return }
        if isVisible() {
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    func updateAllItems(_ viewModels: [ListViewModel]?) {
        guard let viewModels = viewModels else { return }
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func opedEditor(itemID: UUID?) {
        if let viewController = viewControllerFactory?.createListItemViewController(itemID: itemID) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSrouce

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModels.safeItem(at: indexPath.row) else { return UITableViewCell() }
        let cell = ListTableViewCell.dequeue(for: tableView, indexPath: indexPath)
        cell.update(viewModel: viewModel)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.editViewModel(viewModels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: nil) { [weak self] (_, _, completionHandler) in
         self?.interactor?.deleteViewModel(self?.viewModels[indexPath.row])
         completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(named: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: nil) { [weak self] (_, _, completionHandler) in
            self?.interactor?.editViewModel(self?.viewModels[indexPath.row])
            completionHandler(true)
        }
        editAction.image = UIImage(named: "edit")

        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

// MARK: - IListTableViewCell

extension ListViewController: IListTableViewCell {
    func toggle(viewModel: ListViewModel) {
        interactor?.toggle(viewModel: viewModel)
    }
}
