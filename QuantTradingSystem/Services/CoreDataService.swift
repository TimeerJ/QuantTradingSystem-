//
//  CoreDataService.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//
import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    private let persistentContainer: NSPersistentContainer
    
    private init(container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.persistentContainer = container
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - CRUD Operations
    
    // Create or Update an Entity
    func saveEntity<T: NSManagedObject>(_ type: T.Type, updateBlock: (T) -> Void) -> Bool {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        
        do {
            let entities = try context.fetch(fetchRequest)
            let entity = entities.first ?? T(context: context)
            updateBlock(entity)
            try context.save()
            return true
        } catch {
            print("Failed to save entity: \(error)")
            return false
        }
    }
    
    // Fetch Entities
    func fetchEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }
    
    // Delete Entity
    func deleteEntity<T: NSManagedObject>(_ entity: T) -> Bool {
        context.delete(entity)
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to delete entity: \(error)")
            return false
        }
    }
}
