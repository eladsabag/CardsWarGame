//
//  GameManager.swift
//  CardsWarGame
//
//  Created by Student29 on 13/06/2023.
//

import Foundation

protocol GameManagerDelegate {
    func didPassChecks()
    func didFailChecks(errorType: Int, message: String)
}

struct GameManager {
    let middlePoint: Double = 34.817549168324334
    var delegate: GameManagerDelegate?
    var model: GameModel?
    
    func performChecks() {
        if model?.name == nil {
            self.delegate?.didFailChecks(errorType: 0, message: "Please make sure you insert name in order to start game.")
        } else if model?.lat == nil || model?.lon == nil {
            self.delegate?.didFailChecks(errorType: 1, message: "Please make sure you enabled location services in order to start game.")
        } else {
            self.delegate?.didPassChecks()
        }
    }
    
    func isEast() -> Bool {
        guard let myLon = model?.lon else {
            return false
        }
        return myLon > middlePoint
    }
}
