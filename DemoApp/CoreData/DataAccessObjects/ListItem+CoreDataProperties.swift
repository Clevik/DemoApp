//
//  ListItem+CoreDataProperties.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 26.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isOn: Bool
    @NSManaged public var title: String?
    @NSManaged public var dateCreated: Date?

}
