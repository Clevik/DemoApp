//
//  ServiceTableViewCell.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

class ServiceTableViewCell: TableViewCellBase {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var coutnryLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    func update(cdViewModel: CDViewModel) {
        titleLabel.text = cdViewModel.title
        artistLabel.text = cdViewModel.artist
        coutnryLabel.text = cdViewModel.country
        companyLabel.text = cdViewModel.company
        priceLabel.text = cdViewModel.price
        yearLabel.text = cdViewModel.year
    }
}
