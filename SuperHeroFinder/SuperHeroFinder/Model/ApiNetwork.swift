//
//  ApiNetwork.swift
//  SuperHeroFinder
//
//  Created by Hugo López on 09-06-24.
//

import Foundation

class ApiNetwork {
    
    struct Wrapper:Codable{
        let response:String
        let results:[SuperHero]
    }
    
    struct ImageSuperHero:Codable{
        let url:URL?
        
    }
    
    struct SuperHero:Codable, Identifiable{
        let id:String
        let name:String
        let image:ImageSuperHero
    }
    //Details SuperHero
    struct SuperHeroCompleted:Codable{
        let id:String
        let name:String
        let image:ImageSuperHero
        let powerstats:Powerstats
        let biography:Biography
    }
    
    struct Powerstats:Codable{
        let intelligence:String
        let strength:String
        let speed:String
        let durability:String
        let power:String
        let combat:String
    }
    
    struct Biography:Codable{
        let alignment:String
        let publisher:String
        let aliases:[String]
        let fullName:String
        
        enum CodingKeys:String, CodingKey{
            case fullName = "full-name"
            case alignment = "alignment"
            case publisher = "publisher"
            case aliases = "aliases"
        }
    }
    
    func getHeroByQuery(query:String) async throws -> Wrapper{
        let url = URL(string: "https://superheroapi.com/api/79c99fda9894cf4017793cdb40721cb6/search/\(query)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        
        return wrapper
    }
    
    func getHeroById(id:String) async throws -> SuperHeroCompleted{
        let url = URL(string: "https://superheroapi.com/api/79c99fda9894cf4017793cdb40721cb6/\(id)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let superhero = try JSONDecoder().decode(SuperHeroCompleted.self, from: data)
        
        return superhero
    }
}
