//
//  Store.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 26.01.2024.
//

import Foundation
import StoreKit


class Store: ObservableObject {
    static var instance = Store()
    private var productIDs: [String]?
    @Published private (set) var products: [Product]?
    @Published private (set) var purchasedNonConsumables = Set<Product>()
    var transacitonListener: Task<Void, Error>?

    func updateProducts(with productIDs: [String]) {
        self.productIDs = productIDs

        Task {
            await requestProducts()
            await updateCurrentEntitlements()
        }
    }

    private init() {
        transacitonListener = listenForTransactions()
    }

    @MainActor
    func requestProducts() async {
        guard let productIDs else {return}
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print(error)
        }
    }

    func getUnpurchachedProduct(for merchantID: String) -> Product? {
        return Store.instance.products?.first(where: {
            return $0.id == merchantID && !Store.instance.purchasedNonConsumables.contains($0)
        })
    }

    func listenForTransactions() -> Task < Void, Error > {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }

    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
    }

    @MainActor
    private func handle(transactionVerification result: VerificationResult <Transaction> ) async {
      switch result {
        case let.verified(transaction):
          guard
          let product = self.products?.first(where: {
            $0.id == transaction.productID
          })
          else {
            return
          }
          self.purchasedNonConsumables.insert(product)
          await transaction.finish()
        default:
          return
      }
    }

    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
      let result =
        try await product.purchase()
      switch result {
        case .success(.verified(let transaction)):
              purchasedNonConsumables.insert(product)
          await transaction.finish()
          return transaction
        default:
          return nil
      }
    }
}
