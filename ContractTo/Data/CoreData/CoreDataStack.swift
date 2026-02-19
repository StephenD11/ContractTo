//
//  CoreDataStack.swift
//  ContractTo
//
//  Created by Stepan on 16.02.2026.
//

import CoreData
import UIKit

final class CoreDataStack {
    
    private let modelName : String
    
    // MARK: Главный контейнер Core Data
    let persistentContainer: NSPersistentContainer
    
    // MARK: Главный контекст (UI)
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(modelName: String) {
        self.modelName = modelName
        
        persistentContainer = NSPersistentContainer(name: modelName)
        
        // MARK: Persistent store (SQLite файл)
        persistentContainer.loadPersistentStores { desctiption, error in
            if let error = error {
                fatalError("❌ Core Data failed to load: \(error)")
            }
        }
        
        // MARK: Настройка контекста
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        let context = viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("❌ Failed to save context: \(error)")
            }
        }
    }
}
