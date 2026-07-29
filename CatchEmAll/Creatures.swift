//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by Brett Buchholz on 10/10/24.
//

import Foundation

@Observable
@MainActor
class Creatures {
    
    private(set) var count = 0
    private(set) var creaturesArray: [Creature] = []
    private(set) var isLoading = false
    
    private var nextURLString: String? = "https://pokeapi.co/api/v2/pokemon"
    
    private struct Returned: Decodable {
        let count: Int
        let next: String?
        let results: [Creature]
    }
    
    func getData() async {
        guard !isLoading else { return }
        guard let nextURLString,
              let url = URL(string: nextURLString) else {
            return
        }
        
        print("Accessing URL: \(nextURLString)")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP request failed with status code \(httpResponse.statusCode)")
                return
            }
            
            let returned = try JSONDecoder().decode(Returned.self, from: data)
            
            count = returned.count
            self.nextURLString = returned.next
            creaturesArray.append(contentsOf: returned.results)
        } catch {
            print("Failed to load creatures: \(error.localizedDescription)")
        }
    }
    
    func loadNextIfNeeded(creature: Creature) async {
        guard let lastCreature = creaturesArray.last else { return }
        guard creature.id == lastCreature.id else { return }
        guard nextURLString != nil else { return }
        
        await getData()
    }
    
    func loadAll() async {
        while nextURLString != nil {
            await getData()
        }
    }
}
