//
//  GameViewControler.swift
//  CardsWarGame
//
//  Created by Student29 on 15/06/2023.
//

import UIKit

class GameViewController : UIViewController {
    let suits = ["heart", "spades", "diamond", "club"]
    let ranks = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "prince", "queen", "king", "ace"]
    var cardImages: [UIImage] = []
    var timer: Timer?
    var gamesNum = 0
    var westScoreCount = 0
    var eastScoreCount = 0
    
    @IBOutlet weak var westCardImage: UIImageView!
    @IBOutlet weak var eastCardImage: UIImageView!
   
    @IBOutlet weak var eastName: UILabel!
    @IBOutlet weak var eastScore: UILabel!
    
    @IBOutlet weak var westName: UILabel!
    
    @IBOutlet weak var westScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCardImages()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(selectRandomCards), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? GameViewController, let playerName = sender as? String {
            destinationVC.eastName.text = playerName
            destinationVC.westName.text = "PC"
        }
    }
    
    func initCardImages() {
        for suit in suits {
            for rank in ranks {
                if let image = UIImage(named: "\(rank)_\(suit)") {
                    image.accessibilityIdentifier = rank
                    cardImages.append(image)
                }
            }
        }
    }
    
    @objc func selectRandomCards() {
        let randomIndexWest = Int.random(in: 0..<cardImages.count)
        let selectedCardWest = cardImages[randomIndexWest]
        westCardImage.image = selectedCardWest
        cardImages.remove(at: randomIndexWest)
        
        let randomIndexEast = Int.random(in: 0..<cardImages.count)
        let selectedCardEast = cardImages[randomIndexEast]
        eastCardImage.image = selectedCardEast
        cardImages.remove(at: randomIndexEast)
        
        let result = compareImages(imageWest: westCardImage.image!, imageEast: eastCardImage.image!)
        if result == 0 {
            westScoreCount+=1
            westName.text = "\(westScoreCount)"
        }
        if result == 1 {
            eastScoreCount+=1
            eastName.text = "\(eastScoreCount)"
        }
        
        gamesNum+=1
        if gamesNum == 10 {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func compareImages(imageWest: UIImage, imageEast: UIImage) -> Int {
        guard let rankWest = imageWest.accessibilityIdentifier, let rankEast = imageEast.accessibilityIdentifier else {
            return -1
        }
        
        guard let indexWest = ranks.firstIndex(of: rankWest), let indexEast = ranks.firstIndex(of: rankEast) else {
            return -1
        }
        
        if indexWest > indexEast {
            return 0 // west wins
        } else if indexWest < indexEast {
            return 1 // east wins
        } else {
            return -1 // tie
        }
    }
}
