//
//  ListItemDataProvider.swift
//  DemoApp
//
//  Created by Andrey Timonenkov on 25.05.2020.
//  Copyright © 2020 Andrey Timonenkov. All rights reserved.
//

import Foundation
import CoreData

protocol IProvider {
}

typealias InsertedItem = (ListItem) -> Void
typealias DeletedItem = (ListItem) -> Void
typealias UpdatedItem = (ListItem) -> Void

protocol IListItemDataProvider: IProvider {
    var onInsert: InsertedItem? { get set }
    var onDelete: DeletedItem? { get set }
    var onUpdate: UpdatedItem? { get set }
    
    func savedItems() -> [ListItem]?
    func itemWith(itemId: UUID) -> ListItem?
    func insert(title: String)
    func delete(itemId: UUID)
    func update(itemId: UUID, title: String, isOn: Bool)
    func update(itemId: UUID, title: String)
}

class ListItemDataProvider: NSObject {
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<ListItem>
    
    var onInsert: UpdatedItem?
    var onDelete: UpdatedItem?
    var onUpdate: UpdatedItem?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        let sort = NSSortDescriptor(key: "dateCreated", ascending: true)
        request.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
    }
}

// MARK: - IListItemDataProvider

extension ListItemDataProvider: IListItemDataProvider {
    func savedItems() -> [ListItem]? {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects
    }
    
    func itemWith(itemId: UUID) -> ListItem? {
        return savedItems()?.first{ $0.id == itemId }
    }
    
    func insert(title: String) {
        ListItem.create(title: title, context: context)
        try? context.save()
    }
    
    func delete(itemId: UUID) {
        guard let item = itemWith(itemId: itemId) else { return }
        
        context.delete(item)
        try? context.save()
    }
    
    func update(itemId: UUID, title: String, isOn: Bool) {
        guard let item = itemWith(itemId: itemId) else { return }
        item.title = title
        item.isOn = isOn
        try? context.save()
    }
    
    func update(itemId: UUID, title: String) {
        guard let item = itemWith(itemId: itemId) else { return }
        item.title = title
        try? context.save()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ListItemDataProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let anObject = anObject as? ListItem else { return }
        switch type {
        case .insert:
            onInsert?(anObject)
        case .delete:
            onDelete?(anObject)
        case .update:
            onUpdate?(anObject)
        case .move:
            break
        @unknown default:
            break
        }
    }
}
