//
//  ListTableViewCell.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

protocol IListTableViewCell: class {
    func toggle(viewModel: ListViewModel)
}

class ListTableViewCell: TableViewCellBase {
    @IBOutlet weak var activeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    weak var delegate: IListTableViewCell?
    
    private var viewModel: ListViewModel? {
        didSet {
            activeImageView.image = UIImage(named: viewModel?.imageName ?? "contrast")
            titleLabel.text = viewModel?.titleString ?? "list_table_view_cell.unknown_name".localized
            toggleSwitch.setOn(viewModel?.isOn ?? false, animated: false)
        }
    }
    
    func update(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - IBAction

private extension ListTableViewCell {
    @IBAction func toggleSwitchTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        delegate?.toggle(viewModel: viewModel)
    }
}
