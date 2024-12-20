//
//  StoreManager.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//
 
import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var myProducts: [Product] = [] // To hold the list of available products
    @Published var purchasedProducts: Set<String> = [] // Keep track of purchased products
    
    init() {
        fetchProducts() // Fetch products on initialization
        listenForTransactions() // Listen for transaction updates on initialization
    }
    
    // Fetch products using StoreKit 2
    func fetchProducts() {
        Task {
            do {
                // Fetch both products (weekly subscription and surcharge)
                let productIDs = [Products.weekly, Products.surcharge]
                let products = try await Product.products(for: productIDs)
                myProducts = products
                print("Products loaded: \(myProducts)")
            } catch {
                print("Failed to fetch products: \(error.localizedDescription)")
            }
        }
    }
    
    // Purchase a product
    func buyProduct(product: Product) {
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        // Add to purchased products
                        purchasedProducts.insert(product.id)
                        await transaction.finish()
                        print("Purchase verified and finished for product: \(product.id)")
                    case .unverified(_, let error):
                        print("Purchase failed verification: \(error.localizedDescription)")
                    }
                case .userCancelled:
                    print("User canceled the purchase.")
                case .pending:
                    print("Purchase is pending.")
                @unknown default:
                    print("Unknown purchase result.")
                }
            } catch {
                print("Purchase failed: \(error.localizedDescription)")
            }
        }
    }

    // Check the current entitlements for the user
    func checkPurchases() async {
        print("Checking current entitlements...")
        purchasedProducts.removeAll() // Clear old state to ensure fresh check

        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                print("Found verified transaction for product ID: \(transaction.productID)")
                purchasedProducts.insert(transaction.productID)
            } else {
                print("Transaction not verified or not applicable")
            }
        }

        if purchasedProducts.isEmpty {
            print("No active subscriptions found.")
        } else {
            print("Active subscriptions: \(purchasedProducts)")
        }
    }

    // Restore purchases manually if needed
    func restorePurchases() {
        Task {
            print("Restoring purchases...")
            purchasedProducts.removeAll() // Clear old state to ensure fresh restore
            var hasSubscription = false

            for await result in Transaction.currentEntitlements {
                if case let .verified(transaction) = result {
                    purchasedProducts.insert(transaction.productID)
                    print("Restored product ID: \(transaction.productID)")
                    hasSubscription = true
                } else {
                    print("Restored transaction not verified.")
                }
            }

            if hasSubscription {
                print("Restored active subscriptions: \(purchasedProducts)")
            } else {
                print("No active subscriptions found.")
                // Display Apple's standard alert for no active subscriptions
                showNoActiveSubscriptionAlert()
            }
        }
    }
    
    // Display a standard alert to let the user know they have no active subscription
    private func showNoActiveSubscriptionAlert() {
        let alertController = UIAlertController(
            title: "No Active Subscription",
            message: "It looks like you don't have an active subscription to restore.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Listen for ongoing or new transactions
    private func listenForTransactions() {
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    // Handle successful transaction
                    purchasedProducts.insert(transaction.productID)
                    await transaction.finish() // Finish the transaction after processing
                    print("Transaction successful for product ID: \(transaction.productID)")
                case .unverified(_, let error):
                    // Handle failed verification
                    print("Transaction verification failed: \(error.localizedDescription)")
                }
            }
        }
    }

    // Check if a product has been purchased
    func isProductPurchased(_ productID: String) -> Bool {
        let isPurchased = purchasedProducts.contains(productID)
        return isPurchased
    }
}

