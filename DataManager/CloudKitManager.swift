//
//  CloudKitManager.swift
//  hairapp
//
//  Created by Liam Syversen on 11/30/24.
// 

import Foundation
import CloudKit

class CloudKitManager {
    static let shared = CloudKitManager()
    let container = CKContainer(identifier: "iCloud.lsyvesen.hairapp")
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    // Fetch the user record from CloudKit
       func fetchUserRecord(completion: @escaping (CKRecord?, Error?) -> Void) {
           guard let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") else {
               completion(nil, NSError(domain: "CloudKitManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not signed in"]))
               return
           }

           let predicate = NSPredicate(format: "userIdentifier == %@", userIdentifier)
           let query = CKQuery(recordType: "User", predicate: predicate)

           privateDatabase.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 1) { result in
               switch result {
               case .success(let queryResult):
                   var userRecord: CKRecord?

                   for (recordID, recordResult) in queryResult.matchResults {
                       switch recordResult {
                       case .success(let record):
                           userRecord = record
                           break // Exit the loop as we only expect one record
                       case .failure(let error):
                           print("Error fetching record \(recordID): \(error.localizedDescription)")
                       }
                   }

                   completion(userRecord, nil)
               case .failure(let error):
                   completion(nil, error)
               }
           }
       }
    // Save tokens to CloudKit
    func saveUserTokens(hairRatingTokens: Int, hairlineTokens: Int, completion: @escaping (Error?) -> Void) {
        fetchUserRecord { record, error in
            guard let record = record else {
                completion(error ?? NSError(domain: "CloudKitManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Record not found"]))
                return
            }

            // Update the record with the new token values
            record["hairRatingTokens"] = hairRatingTokens
            record["hairlineTokens"] = hairlineTokens

            self.privateDatabase.save(record) { _, error in
                completion(error)
            }
        }
    }

    // Create a new user record
    func createUserRecord(completion: @escaping (CKRecord?, Error?) -> Void) {
        guard let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") else {
            completion(nil, NSError(domain: "CloudKitManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not signed in"]))
            return
        }

        let userRecord = CKRecord(recordType: "User")
        userRecord["userIdentifier"] = userIdentifier
        userRecord["hairRatingTokens"] = 1
        userRecord["hairlineTokens"] = 1

        privateDatabase.save(userRecord) { record, error in
            completion(record, error)
        }
    }
}

