//
//  DatabaseService.swift
//  SwiftDataService
//
//  Created by Fabio Dantas on 27/11/2025.
//


import Foundation
import SwiftData

class DatabaseService {
    
    static let shared = DatabaseService()
    private let schema = Schema([
        // Define Models Here
        User.self
    ])
    
    private(set) var container: ModelContainer?
    
    // Long-lived background context for batch operations
    private var backgroundContext: ModelContext?
    
    private func ensureBackgroundContext() {
        if backgroundContext == nil, let container {
            backgroundContext = ModelContext(container)
        }
    }
    
    func setup(name: String) throws {
        guard container == nil else { return }
        let appSupportDir = URL.applicationSupportDirectory
        try FileManager.default.createDirectory(at: appSupportDir, withIntermediateDirectories: true)
        let databasePath = appSupportDir.appending(path: "default.store.\(name)")
        let config = ModelConfiguration(url: databasePath)
        container = try ModelContainer(for: schema, configurations: config)
        self.backgroundContext = ModelContext(container!)
    }
    
    @MainActor
    var mainContext: ModelContext? { container?.mainContext }
    
    private func makeBackgroundContext() -> ModelContext? {
        guard let container else { return nil }
        return ModelContext(container)
    }
    
    /// Returns a long-lived background context intended for batch operations.
    /// Falls back to creating a new one if unavailable.
    private func longLivedBackgroundContext() -> ModelContext? {
        ensureBackgroundContext()
        return backgroundContext ?? makeBackgroundContext()
    }
    
    // Note: These methods default to a background context. If you need main-context operations for UI-bound flows, pass
    // DatabaseService.shared.mainContext from the main actor. Avoid crossing actor boundaries when using contexts.
    func save<T: PersistentModel>(item: T, in context: ModelContext? = nil) throws {
        let ctx = context ?? makeBackgroundContext()
        guard let ctx else { return }
        ctx.insert(item)
        try ctx.save()
    }
    
    func save<T: PersistentModel>(items: [T], in context: ModelContext? = nil) throws {
        let ctx = context ?? makeBackgroundContext()
        guard let ctx else { return }
        for item in items {
            ctx.insert(item)
        }
        try ctx.save()
    }
    
    /// Saves a large collection of items in batches to reduce memory usage and save time.
    func saveInBatches<T: PersistentModel>(
        items: [T],
        batchSize: Int = 1000,
        in context: ModelContext? = nil
    ) throws {
        precondition(batchSize > 0, "batchSize must be greater than zero")
        let ctx = context ?? longLivedBackgroundContext() ?? makeBackgroundContext()
        guard let ctx else { return }
        var count = 0
        for item in items {
            ctx.insert(item)
            count += 1
            if count % batchSize == 0 {
                try ctx.save()
            }
        }
        // Save any remaining items that didn't fill the last batch
        if count % batchSize != 0 {
            try ctx.save()
        }
    }
    
    func delete<T: PersistentModel>(items: [T], in context: ModelContext? = nil) throws {
        let ctx = context ?? makeBackgroundContext()
        guard let ctx else { return }
        for item in items {
            ctx.delete(item)
        }
        try ctx.save()
    }
    
    func delete<T: PersistentModel>(item: T, in context: ModelContext? = nil) throws {
        let ctx = context ?? makeBackgroundContext()
        guard let ctx else { return }
        ctx.delete(item)
        try ctx.save()
    }
    
    func deleteAll<T: PersistentModel>(predicate: Predicate<T>?, type: T.Type, in context: ModelContext? = nil) throws {
        let ctx = context ?? makeBackgroundContext()
        guard let ctx else { return }
        try ctx.delete(model: type, where: predicate, includeSubclasses: true)
    }
    
    func fetchAll<T: PersistentModel>(
        predicate: Predicate<T>? = nil,
        type: T.Type,
        sortBy: [SortDescriptor<T>] = [],
        fetchLimit: Int? = nil,
        in context: ModelContext? = nil
    ) throws -> [T] {
        let ctx = context ?? makeBackgroundContext()
        guard let ctx else { return [] }
        var descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        if let fetchLimit { descriptor.fetchLimit = fetchLimit }
        return try ctx.fetch(descriptor)
    }
}

