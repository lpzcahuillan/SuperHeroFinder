//
//  ContentView.swift
//  superHeroFinder
//
//  Created by Hugo López on 06-06-24.
//

import SwiftUI

struct ContentView: View {
    @State var name:String = ""
    @State var wrapper:ApiNetwork.Wrapper? = nil
    var body: some View {
        NavigationStack {
            VStack {
                TextField(text: $name, prompt: Text("Ingresa el nombre de tu heroe")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.purple1.opacity(0.3))
                ) {}
                    .font(.title2)
                    .bold()
                    .frame(height: 40.0)
                    .padding()
                    .foregroundColor(.backgroundApp)
                    .background(.white)
                    .onSubmit {
                        Task{
                            do{
                                wrapper = try await ApiNetwork().getHeroByQuery(query: name)
                            }
                            catch{
                                print("Error")
                            }
                        }
                    }
                    .cornerRadius(24)
                List(wrapper?.results ?? []){ superhero in
                    ZStack{
                        superHeroItem(superhero: superhero)
                        NavigationLink(destination: DetailView(id: superhero.id)){EmptyView()}.opacity(0)
                    }.listRowBackground(Color.backgroundApp)
                }
                .listStyle(.plain)
                .cornerRadius(16)
                .background(.backgroundApp)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundApp)
        }
    }
}

struct superHeroItem: View {
    let superhero:ApiNetwork.SuperHero
    var body: some View {
        ZStack{
            AsyncImage(url: superhero.image.url) { phase in
                        switch phase {
                        case .empty:
                            // Placeholder mientras se carga la imagen
                            ProgressView()
                                .frame(width: 200, height: 200)
                        case .success(let image):
                            // Si la imagen se carga con éxito, aplicar modificadores a la imagen
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                        case .failure:
                            // Si la carga de la imagen falla
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        @unknown default:
                            // Manejar cualquier nuevo caso que pueda ser agregado en el futuro
                            EmptyView()
                        }
                    }
            
            VStack{
                Spacer()
                Text(superhero.name).foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.purple4.opacity(0.3))
                
                
            }
        }
        .frame(height: 200)
        .cornerRadius(16)
        .listRowBackground(Color.component)
    }
}


#Preview {
    ContentView()
}
