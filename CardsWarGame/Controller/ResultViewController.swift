//
//  ResultViewController.swift
//  CardsWarGame
//
//  Created by Student29 on 17/06/2023.
//

import UIKit

class ResultViewController : UIViewController {
    var playerName: String?
    var playerScore: Int?
    @IBOutlet weak var winnerName: UILabel!
    @IBOutlet weak var winnerScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews() {
        winnerName.text = "Winner: \(playerName!)"
        winnerScore.text = "Score: \(playerScore!)"
    }

    @IBAction func onBackToMenuPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "navigateToHome", sender: self)
    }
}
