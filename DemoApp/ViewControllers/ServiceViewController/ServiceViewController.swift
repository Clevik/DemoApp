//
//  ServiceViewController.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 24.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

protocol IServiceViewController: UIViewController {
    func addCDViewModel(_ cd: CDViewModel)
}

class ServiceViewController: UIViewController {
    enum ReloadButtonState {
        case ready, busy
    }

    @IBOutlet weak var tableView: UITableView!

    private var interactor: IServiceViewControllerInteractor?
    private var cds: [CDViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(refreshButtonTouchUpInside(_:)))
        
        updateReloadButtonState(.ready)
        ServiceTableViewCell.registerNib(for: tableView)
        tableView.dataSource = self
    }

    class func create(interactor: IServiceViewControllerInteractor?) -> ServiceViewController {
        let viewController = self.fromStoryboard(.main, identifier: nameOfClass())
        viewController.title = "service_view_controller.title".localized
        viewController.interactor = interactor
        return viewController
    }
}

// MARK: - IServiceViewController

extension ServiceViewController: IServiceViewController {
    func addCDViewModel(_ cd: CDViewModel) {
        cds.append(cd)

        tableView.beginUpdates()
        let indexPaths = [IndexPath(item: cds.count - 1, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - IBAction

private extension ServiceViewController {
    @IBAction func refreshButtonTouchUpInside(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        cds = []
        tableView.reloadData()
        updateReloadButtonState(.busy)

        interactor?.loadAndParseXML{ [weak self] in
            self?.updateReloadButtonState(.ready)
        }
    }
}

// MARK: - UITableViewDataSrouce

extension ServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cdViewModel = cds.safeItem(at: indexPath.row) {
            let cell = ServiceTableViewCell.dequeue(for: tableView, indexPath: indexPath)
            cell.update(cdViewModel: cdViewModel)
            return cell
        }

        return UITableViewCell()
    }
}

// MARK: - Private

private extension ServiceViewController {
    func updateReloadButtonState(_ state: ReloadButtonState) {
        var enabled = true
        switch state {
        case .ready:
            enabled = true
            title = "service_view_controller.title".localized
        case .busy:
            enabled = false
            title = "service_view_controller.title.loading".localized
        }
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
}
