//
//  TableViewCellBase.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import UIKit

class TableViewCellBase: UITableViewCell {
    class func reuseIdentifier() -> String {
        return nameOfClass()
    }

    class func nib() -> UINib? {
        let name = nameOfClass()
        return UINib(nibName: name, bundle: nil)
    }

    class func registerClass(for tableView: UITableView?) {
        tableView?.register(self, forCellReuseIdentifier: reuseIdentifier())
    }

    class func registerNib(for tableView: UITableView?) {
        tableView?.register(nib(), forCellReuseIdentifier: reuseIdentifier())
    }

    class func dequeue(for tableView: UITableView,
                       indexPath: IndexPath) -> Self {
        return dequeCell(for: tableView, indexPath: indexPath)
    }
}

// MARK: - Private methods

private extension TableViewCellBase {
    class func dequeCell<T: TableViewCellBase>(for tableView: UITableView,
                                               indexPath: IndexPath) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier(), for: indexPath) as! T
        return cell
    }
}
