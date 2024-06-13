//
//  DetailView.swift
//  SuperHeroFinder
//
//  Created by Hugo López on 09-06-24.
//

import SwiftUI
import SDWebImageSwiftUI
import Charts

struct DetailView: View {
    let id:String
    
    @State var superhero:ApiNetwork.SuperHeroCompleted? = nil
    @State var loading:Bool = true
    
    var body: some View {
        VStack{
            VStack{
                if loading{
                    ProgressView().tint(.white)
                }else if let superhero = superhero{
                    WebImage(url: superhero.image.url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(16)
                    ForEach(superhero.biography.aliases, id: \.self){ alias in
                        Text(alias).font(.title3).foregroundColor(.gray).italic()
                    }
                    VStack {
                        Text("Stats").font(.title2).bold().foregroundColor(.white)
                        SuperheroStats(stats: superhero.powerstats)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .background(.purple1)
                    .cornerRadius(16)
                    .padding(.bottom, 12.0)
                    Spacer()
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(.component)
            .cornerRadius(16)
            .padding(5)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(.backgroundApp)
        .onAppear{
            Task{
                do{
                    superhero = try await ApiNetwork().getHeroById(id: id)
                }catch{
                    superhero = nil
                }
                loading = false
            }
        }
        .toolbar{
            ToolbarItem(placement: .principal){
                Text("\(superhero?.name ?? "name")").font(.title).bold().foregroundStyle(.white)
            }
        }
    }
}

struct SuperheroStats:View {
    let stats:ApiNetwork.Powerstats
    var body: some View {
        VStack{
            
            Chart{
                SectorMark(angle: .value("Count",Int(stats.combat) ?? 0),
                           innerRadius: .ratio(0.6),
                           angularInset: 5
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Combat"))
                
                SectorMark(angle: .value("Count",Int(stats.durability) ?? 0),
                           innerRadius: .ratio(0.6),
                           angularInset: 5
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Durability"))
                
                SectorMark(angle: .value("Count",Int(stats.intelligence) ?? 0),
                           innerRadius: .ratio(0.6),
                           angularInset: 5
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Intelligence"))
                
                SectorMark(angle: .value("Count",Int(stats.power) ?? 0),
                           innerRadius: .ratio(0.6),
                           angularInset: 5
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Power"))
                
                SectorMark(angle: .value("Count",Int(stats.speed) ?? 0),
                           innerRadius: .ratio(0.6),
                           angularInset: 5
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Speed"))
                
                SectorMark(angle: .value("Count",Int(stats.strength) ?? 0),
                           innerRadius: .ratio(0.6),
                           angularInset: 5
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Strength"))
            }
            
        }.padding(16).frame(maxWidth: .infinity, maxHeight: 350)
            .background(.white)
            .cornerRadius(16)
            .padding(.horizontal, 24)
    }
}


#Preview {
    DetailView(id: "4")
}
