//
//  ListItem+CoreDataClass.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//
//

import Foundation
import CoreData


public class ListItem: NSManagedObject {
    @discardableResult
    class func create(title: String, context: NSManagedObjectContext) -> ListItem {
        let item = ListItem(entity: ListItem.entity(), insertInto: context)
        item.id = UUID()
        item.title = title
        item.isOn = false
        item.dateCreated = Date()
        return item
    }
}
