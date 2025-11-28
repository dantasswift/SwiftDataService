//
//  UserViewModel.swift
//  SwiftDataService
//
//  Created by Fabio Dantas on 27/11/2025.
//

import Foundation

@Observable
class UserViewModel {
    
    var users: [User] = []
    
    init() {
        loadUsers()
    }
    
    func loadUsers() {
        // Fetch All Users
        do {
            users = try DatabaseService.shared.fetchAll(type: User.self)
        } catch {
            print("Unable to fetch users")
        }
    }
    
    func filterUsers() {
        // Fetch users by predicate
        do {
            do {
                users = try DatabaseService.shared.fetchAll(predicate: #Predicate {$0.age > 20}, type: User.self, sortBy: [SortDescriptor(\User.firstName, order: .forward)], fetchLimit: 10)
            } catch {
                print("Unable to fetch users")
            }
        }
    }
    
    func generateRandomUsers() {
        guard users.isEmpty else {return}
        let randomUsers = [
            User(firstName: "John", lastName: "Smith", age: 28),
            User(firstName: "Jane", lastName: "Doe", age: 32),
            User(firstName: "Alice", lastName: "Brown", age: 29),
            User(firstName: "Bob", lastName: "White", age: 35)
        ]
        users.append(contentsOf: randomUsers)
        saveUsers(users: randomUsers)
    }
    
    func saveUsers(users: [User]) {
        do {
            try DatabaseService.shared.save(items: users)
        } catch {
            print("Failed to save users")
        }
    }
}
