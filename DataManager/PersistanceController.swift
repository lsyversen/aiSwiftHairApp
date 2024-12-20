//
//  PersistanceController.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "hairapp")

        // Enable lightweight migration and configure the persistent store for permanent storage
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("hairapp.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true

        // For in-memory option, only used for testing or previews
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        // Set persistent store description
        container.persistentStoreDescriptions = [description]

        // Load persistent stores with proper error handling
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Log error instead of crashing the app
                print("Unresolved error loading persistent store: \(error), \(error.userInfo)")
                // Handle recovery here, such as deleting the store or resetting the app state
            }
        }
    }

    // Helper function to save context with proper error handling
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                // Log the error instead of crashing
                print("Unresolved error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
