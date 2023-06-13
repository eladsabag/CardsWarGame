//
//  GameModel.swift
//  CardsWarGame
//
//  Created by Student29 on 13/06/2023.
//

import Foundation

struct GameModel {
    var name: String?
    var lat: Double?
    var lon: Double?
    
    init(name: String? = nil, lat: Double? = nil, lon: Double? = nil) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}
