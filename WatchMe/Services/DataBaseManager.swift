//
//  DataBaseManager.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation
import CoreData

protocol DataManagering {
    var context: NSManagedObjectContext { get }
    func saveContext()
    func removeAllModel<T: NSManagedObject>(entity: T.Type)
    func fetch<T: NSManagedObject>(entity: T.Type) -> [T]
}

final class DataBaseManager: DataManagering {
    
    private lazy var persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Can't load persistent store: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        persistenContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func removeAllModel<T: NSManagedObject>(entity: T.Type) {
        let entityName = String(describing: entity)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("ERROR then remove All Model")
        }
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type) -> [T] {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        guard let items = try? context.fetch(fetchRequest) else { return [] }
        return items
    }
}
