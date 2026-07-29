//
//  DetailView.swift
//  CatchEmAll
//
//  Created by Brett Buchholz on 10/14/24.
//

import SwiftUI

struct DetailView: View {
    
    let creature: Creature
    
    @State private var creatureDetail = CreatureDetail()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(creature.name.capitalized)
                .font(.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
                .padding(.bottom)
            
            HStack {
                creatureImage
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(creatureDetail.height.formatted(.number.precision(.fractionLength(1))))
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    HStack(alignment: .top) {
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(creatureDetail.weight.formatted(.number.precision(.fractionLength(1))))
                            .font(.largeTitle)
                            .bold()
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .task {
            creatureDetail.urlString = creature.url
            await creatureDetail.getData()
        }
    }
}

private extension DetailView {
    
    var creatureImage: some View {
        AsyncImage(url: URL(string: creatureDetail.imageURL)) { phase in
            Group {
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Image(systemName: "questionmark.square.dashed")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                } else {
                    ProgressView()
                        .scaleEffect(2.0)
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 8, x: 5, y: 5)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            }
        }
        .frame(width: 96, height: 96)
        .padding(.trailing)
    }
}

#Preview {
    DetailView(
        creature: Creature(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
    )
}
