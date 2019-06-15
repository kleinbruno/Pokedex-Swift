//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bruno Klein on 08/06/19.
//  Copyright © 2019 CWI Software. All rights reserved.
//

import Foundation

struct PokemonResponse: Codable {
    
    let list: PokemonList
    
}

struct PokemonList: Codable {
    let pokemons: [Pokemon]
}

struct Status: Codable {
    let value: Int
    let name: String
}

struct Pokemon: Codable {
    var id: String
    let name: String
    let image: String
    let types: [PokemonType]
    let description: String?
    let stats: [Status]?
}
