//
//  GameManager.swift
//  CardsWarGame
//
//  Created by Student29 on 13/06/2023.
//

import Foundation

protocol HomeManagerDelegate {
    func didPassChecks()
    func didFailChecks(errorType: Int)
}

class HomeManager {
    let middlePoint: Double = 34.817549168324334
    var delegate: HomeManagerDelegate?
    var model: HomeModel?
    
    init(delegate: HomeManagerDelegate? = nil, model: HomeModel? = nil) {
        self.delegate = delegate
        self.model = model
    }

    func performChecks() {
        if model?.name == nil {
            self.delegate?.didFailChecks(errorType: 0)
        } else if model?.lat == nil || model?.lon == nil {
            self.delegate?.didFailChecks(errorType: 1)
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
