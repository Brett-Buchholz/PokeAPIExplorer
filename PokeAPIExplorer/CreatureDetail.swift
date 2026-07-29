//
//  CreatureDetail.swift
//  CatchEmAll
//
//  Created by Brett Buchholz on 10/15/24.
//

import Foundation

@Observable
class CreatureDetail {
    
    var urlString = ""
    var height = 0.0
    var weight = 0.0
    var imageURL = ""
    
    private struct Returned: Decodable {
        let height: Double
        let weight: Double
        let sprites: Sprite
    }
    
    private struct Sprite: Decodable {
        let other: Other
    }
    
    private struct Other: Decodable {
        let officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    private struct OfficialArtwork: Decodable {
        let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    func getData() async {
        print("Accessing URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
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
            
            height = returned.height
            weight = returned.weight
            imageURL = returned.sprites.other.officialArtwork.frontDefault ?? ""
        } catch {
            print("Failed to load creature details: \(error.localizedDescription)")
        }
    }
}

