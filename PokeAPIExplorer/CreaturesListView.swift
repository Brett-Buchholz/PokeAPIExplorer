//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by Brett Buchholz on 10/9/24.
//

import SwiftUI

struct CreaturesListView: View {
    
    @State private var creatures = Creatures()
    @State private var searchText = ""
    
    private var searchResults: [Creature] {
        guard !searchText.isEmpty else {
            return creatures.creaturesArray
        }
        
        return creatures.creaturesArray.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(Array(searchResults.enumerated()), id: \.element.id) { index, creature in
                        NavigationLink {
                            DetailView(creature: creature)
                        } label: {
                            Text("\(index + 1). \(creature.name.capitalized)")
                                .font(.title2)
                        }
                        .task {
                            await creatures.loadNextIfNeeded(creature: creature)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokémon")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creatures.loadAll()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("\(creatures.creaturesArray.count) of \(creatures.count) creatures")
                    }
                }
                .searchable(text: $searchText)
                
                if creatures.isLoading {
                    ProgressView()
                        .scaleEffect(4.0)
                }
            }
        }
        .task {
            await creatures.getData()
        }
    }
}

#Preview {
    CreaturesListView()
}
