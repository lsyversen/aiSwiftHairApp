//
//  ScanViewModel.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import SwiftUI
import CoreData

class ScanViewModel: ObservableObject {
    @Published var scans: [ScanResult] = []
    @Published var hairlineScans: [Hairline] = [] // New state to manage hairline scans
    @Published var progressPics: [ProgressPic] = []
    @Published var routineItems: [String] = []

    // Tracking the number of scans completed for each type
    @Published var hairRatingScansCompleted: Int = 0
    @Published var hairlineScansCompleted: Int = 0

    // Store the additional scan allowance after surcharge purchase
    @Published var hasPurchasedSurcharge: Bool = false

    // Tokens for each scan type
    @Published var hairRatingTokens: Int = 0 {
        didSet {
            if hairRatingTokens < 0 { hairRatingTokens = 0 }
            saveTokensToCloudKit() // Save to CloudKit when updated
        }
    }
    @Published var hairlineTokens: Int = 0 {
        didSet {
            if hairlineTokens < 0 { hairlineTokens = 0 }
            saveTokensToCloudKit() // Save to CloudKit when updated
        }
    }

    private var context: NSManagedObjectContext
    private var routineGenerator = GenerateRoutineModel()

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchScans()
        fetchHairlineScans()
        fetchProgressPics()
        loadTokensFromCloudKit() // Load tokens from CloudKit during initialization
    }

    // Load tokens from CloudKit
    private func loadTokensFromCloudKit() {
        CloudKitManager.shared.fetchUserRecord { [weak self] record, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let record = record {
                    self.hairRatingTokens = record["hairRatingTokens"] as? Int ?? 0
                    self.hairlineTokens = record["hairlineTokens"] as? Int ?? 0
                } else if let error = error {
                    print("Error fetching tokens from CloudKit: \(error.localizedDescription)")
                }
            }
        }
    }

    // Save tokens to CloudKit
    private func saveTokensToCloudKit() {
        CloudKitManager.shared.saveUserTokens(hairRatingTokens: hairRatingTokens, hairlineTokens: hairlineTokens) { error in
            if let error = error {
                print("Error saving tokens to CloudKit: \(error.localizedDescription)")
            }
        }
    }

    // Method to check if there are any tokens left for a specific scan type
    func hasTokens(for scanType: String) -> Bool {
        switch scanType {
        case "hairrating":
            return hairRatingTokens > 0
        case "hairline":
            return hairlineTokens > 0
        default:
            return false
        }
    }

    // Add logic to increment scan counts and reset tokens
    func incrementScanCount(for scanType: String) {
        switch scanType {
        case "hairrating":
            if hairRatingTokens > 0 {
                hairRatingScansCompleted += 1
                hairRatingTokens -= 1 // Decrease token after completing a scan
            }
        case "hairline":
            if hairlineTokens > 0 {
                hairlineScansCompleted += 1
                hairlineTokens -= 1 // Decrease token after completing a scan
            }
        default:
            break
        }
    }

    // Check if the user can perform a scan based on tokens
    func canPerformScan(ofType scanType: String) -> Bool {
        switch scanType {
        case "hairrating":
            return hairRatingTokens > 0
        case "hairline":
            return hairlineTokens > 0
        default:
            return false
        }
    }

    // Grant a token for the given scan type when surcharge is purchased
    func grantToken(for scanType: String) {
        switch scanType {
        case "hairrating":
            hairRatingTokens += 1
        case "hairline":
            hairlineTokens += 1
        default:
            break
        }
    }

    // Grant initial tokens when a user subscribes for the first time
    func grantInitialTokensForSubscription() {
        if hairRatingTokens == 0 && hairlineTokens == 0 {
            hairRatingTokens = 1
            hairlineTokens = 1
        }
    }

    // Grant tokens for each scan type on subscription renewal
    func grantTokensOnRenewal() {
        hairRatingTokens += 1
        hairlineTokens += 1
    }

    // Reset scan counts after surcharge purchase
    func resetSurchargeAccess() {
        hasPurchasedSurcharge = false
        hairRatingScansCompleted = 0
        hairlineScansCompleted = 0
    }

    // Method to add a completed hair analysis scan
    func addCompletedScan(image: UIImage, result: String, metrics: [String: Any]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            // Create a new ScanResult object
            let scan = ScanResult(context: self.context)
            scan.uuid = UUID()
            scan.date = Date() // Current date

            // Set the properties from the metrics dictionary safely
            scan.overall = metrics["Overall"] as? Double ?? 0.0
            scan.potential = metrics["Potential"] as? Double ?? 0.0
            scan.frizzlevel = metrics["Frizz Level"] as? Double ?? 0.0
            scan.hairdensity = metrics["Hair Density"] as? Double ?? 0.0
            scan.shine = metrics["Shine"] as? Double ?? 0.0
            scan.volume = metrics["Volume"] as? Double ?? 0.0

            scan.hairthickness = metrics["Hair Thickness"] as? String ?? "Unknown"
            scan.haircolor = metrics["Hair Color"] as? String ?? "Unknown"
            scan.hairtype = metrics["Hair Type"] as? String ?? "Unknown"
            scan.faceShape = metrics["Face Shape"] as? String ?? "Unknown"

            // Convert image to Data and assign to imageData
            scan.imageData = image.pngData()

            // Save the scan to Core Data and reset the token
            self.saveScan {
                self.hairRatingTokens = 0 // Reset token after saving
            }

            // Log to check if the scan is being added correctly
            print("Saving hair analysis scan with UUID: \(scan.uuid?.uuidString ?? "No UUID")")

            // Update the scans list on the main thread
            DispatchQueue.main.async {
                self.scans.append(scan)
                self.fetchScans() // Refresh after saving the scan
            }
        }
    }

    // Method to add a completed hairline scan
    func addCompletedHairlineScan(hairlineImage: UIImage, topOfHeadImage: UIImage, hairlossStage: String, topOfHeadStage: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            // Create a new Hairline object
            let hairlineScan = Hairline(context: self.context)
            hairlineScan.uuid = UUID()
            hairlineScan.date = Date()
            hairlineScan.hairlossStage = hairlossStage
            hairlineScan.hairlineImageData = hairlineImage.pngData()
            hairlineScan.topOfHeadImageData = topOfHeadImage.pngData()
            // Save the hairline scan to Core Data and reset the token
            self.saveHairlineScan {
                self.hairlineTokens = 0 // Reset token after saving
            }

            // Log to check if the hairline scan is being added correctly
            print("Saving hairline scan with UUID: \(hairlineScan.uuid?.uuidString ?? "No UUID")")

            DispatchQueue.main.async {
                self.hairlineScans.append(hairlineScan)
                self.fetchHairlineScans() // Refresh after saving
            }
        }
    }

    // Save a hair analysis scan to Core Data
    private func saveScan(completion: (() -> Void)? = nil) {
        context.performAndWait {
            do {
                try context.save()
                PersistenceController.shared.saveContext()
                print("Hair analysis scan saved successfully.")
                completion?() // Reset token after saving
            } catch {
                print("Failed to save scan: \(error.localizedDescription)")
            }
        }
    }

    // Save a hairline scan to Core Data
    private func saveHairlineScan(completion: (() -> Void)? = nil) {
        context.performAndWait {
            do {
                try context.save()
                PersistenceController.shared.saveContext()
                print("Hairline scan saved successfully.")
                completion?() // Reset token after saving
            } catch {
                print("Failed to save hairline scan: \(error.localizedDescription)")
            }
        }
    }

    // Fetch hair analysis scans from Core Data
    func fetchScans() {
        let request: NSFetchRequest<ScanResult> = ScanResult.fetchRequest()
        do {
            let fetchedScans = try context.fetch(request)
            DispatchQueue.main.async {
                self.scans = fetchedScans
            }
        } catch {
            print("Error fetching scans: \(error.localizedDescription)")
        }
    }

    // Fetch hairline scans from Core Data
    func fetchHairlineScans() {
        let request: NSFetchRequest<Hairline> = Hairline.fetchRequest()
        do {
            let fetchedHairlineScans = try context.fetch(request)
            DispatchQueue.main.async {
                self.hairlineScans = fetchedHairlineScans
            }
        } catch {
            print("Error fetching hairline scans: \(error.localizedDescription)")
        }
    }

    // Check if a scan of a specific type has been completed
    func hasCompletedScan(ofType scanType: String) -> Bool {
        switch scanType {
        case "hairrating":
            return !scans.isEmpty
        case "hairline":
            return !hairlineScans.isEmpty
        default:
            return false
        }
    }

    // Method to clear all scans (hair analysis)
    func clearAllScans() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ScanResult.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            DispatchQueue.main.async {
                self.scans.removeAll() // Update the local scans array
            }
        } catch {
            print("Failed to delete all scans: \(error.localizedDescription)")
        }
    }

    // New method to clear all hairline scans
    func clearAllHairlineScans() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Hairline.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            DispatchQueue.main.async {
                self.hairlineScans.removeAll() // Update the local hairline scans array
            }
        } catch {
            print("Failed to delete all hairline scans: \(error.localizedDescription)")
        }
    }

    // Function to save progress pic to Core Data
    func saveProgressPic(image: UIImage) {
        let newProgressPic = ProgressPic(context: context)
        newProgressPic.image = image.pngData()
        newProgressPic.date = Date()

        do {
            try context.save()
            PersistenceController.shared.saveContext()
            fetchProgressPics() // Refresh the data after saving
        } catch {
            print("Failed to save progress pic: \(error.localizedDescription)")
        }
    }

    // Function to fetch progress pics from Core Data
    func fetchProgressPics() {
        let request: NSFetchRequest<ProgressPic> = ProgressPic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let fetchedPics = try context.fetch(request)
            DispatchQueue.main.async {
                self.progressPics = fetchedPics
            }
        } catch {
            print("Failed to fetch progress pics: \(error.localizedDescription)")
        }
    }

    // Maintenance function to reduce Core Data file size
    private func performMaintenance() {
        context.perform {
            self.context.processPendingChanges()
            let coordinator = self.context.persistentStoreCoordinator
            guard let store = coordinator?.persistentStores.first,
                  let storeURL = coordinator?.url(for: store) else { return }

            do {
                try coordinator?.remove(store)
                try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                print("Core Data Maintenance: Successfully pruned database.")
            } catch {
                print("Core Data Maintenance Error: \(error.localizedDescription)")
            }
        }
    }
}



