//
//  TimerHandler.swift
//  CardsWarGame
//
//  Created by Student29 on 17/06/2023.
//

import Foundation

protocol TimerHandlerDelegate {
    func onCardFaceUp()
    func onCardFaceDown()
}

class TimerHandler {
    var timer: Timer?
    var counter = 0
    var delegate: TimerHandlerDelegate?
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        counter = 0
    }
    
    @objc func timerTick() {
        counter += 1
        if counter <= 3 {
            if counter == 3 {
                delegate?.onCardFaceDown()
            }
        } else if counter > 3 && counter <= 8 {
            if counter == 8 {
                delegate?.onCardFaceUp()
                counter = 0
            }
        }
    }
}
