//
//  ContentView.swift
//  SwiftDataService
//
//  Created by Fabio Dantas on 27/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var viewModel: UserViewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text("\(user.firstName) \(user.lastName)")
                            Text("Age: \(user.age)")
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        generateTestUsers()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarSpacer()
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.filterUsers()
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
    
    private func generateTestUsers() {
        viewModel.generateRandomUsers()
    }
    
    private func filterUsers() {
        viewModel.filterUsers()
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
