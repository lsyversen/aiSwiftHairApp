//
//  UserModel.swift
//  hairapp
//
//  Created by Liam Syversen on 11/28/24.
//

import Foundation
import CoreData

class UserModel {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    /// Determines if the user is a paid user
    func isUserPaid() -> Bool {
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                return user.isPaidUser
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
        return false
    }

    /// Saves the isPaidUser value for the user
    func saveIsUserPaid(_ isPaid: Bool) {
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            let users = try context.fetch(fetchRequest)
            
            if let user = users.first {
                user.isPaidUser = isPaid
            } else {
                // Create a new User entity if one doesn't exist
                let newUser = User(context: context)
                newUser.isPaidUser = isPaid
            }
            
            try context.save()
            print("Successfully saved isPaidUser as \(isPaid)")
        } catch {
            print("Error saving isPaidUser: \(error.localizedDescription)")
        }
    }

    /// Fetches the isPaidUser value from Core Data
    func fetchIsUserPaid() -> Bool {
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                return user.isPaidUser
            }
        } catch {
            print("Error fetching isPaidUser: \(error.localizedDescription)")
        }
        return false
    }
}

