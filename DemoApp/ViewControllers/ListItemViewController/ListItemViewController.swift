//
//  ListItemViewController.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

protocol IListItemViewController: UIViewController {
    func close()
    func showAlert(title: String, text: String)
    func showError(title: String, text: String)
    func updateName(_ name: String)
}

class ListItemViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    private var interactor: IListItemViewControllerInteractor?
    private var itemID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonTouchUpInside(_:)))
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                target: self,
                                                action: #selector(cancelButtonTouchUpInside(_:)))
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTouchUpInside(_:)))

        navigationItem.leftBarButtonItems = [backBarButtonItem, leftBarButtonItem];
        interactor?.loadItem(id: itemID)
    }
    
    class func create(itemID: UUID?,
                      interactor: IListItemViewControllerInteractor?) -> ListItemViewController {
        let viewController = self.fromStoryboard(.main, identifier: nameOfClass())
        viewController.title = "list_item_view_controller.title.default".localized
        viewController.itemID = itemID
        viewController.interactor = interactor
        return viewController
    }
}

// MARK: - IListItemViewController

extension ListItemViewController: IListItemViewController {
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, text: String) {
        let alertView = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let saveAlertAction = UIAlertAction(title: "yes".localized,
                                            style: .default) { [weak self] (_) in
            self?.interactor?.saveItem(id: self?.itemID, title: self?.textField.text)
        }
        let cancelAlertAction = UIAlertAction(title: "no".localized,
                                              style: .destructive) { [weak self] (_) in
            self?.interactor?.cancel()
        }
        alertView.addAction(saveAlertAction)
        alertView.addAction(cancelAlertAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func showError(title: String, text: String) {
        let alertView = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "ok".localized, style: .default)
        alertView.addAction(okAlertAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func updateName(_ name: String) {
        textField.text = name
    }
}

// MARK: - IBAction

private extension ListItemViewController {
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        interactor?.requestSaveItem(title: textField.text)
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        interactor?.saveItem(id: itemID, title: textField.text)
    }
    
    @IBAction func cancelButtonTouchUpInside(_ sender: Any) {
        interactor?.cancel()
    }
}
