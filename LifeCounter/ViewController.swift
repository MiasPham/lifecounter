//
//  ViewController.swift
//  LifeCounter
//
//  Created by Mia Pham on 4/15/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lifeCountLabel: UILabel!
    @IBOutlet weak var lifeCountTwoLabel: UILabel!
    @IBOutlet weak var result: UILabel!
    var lifeCounts: [Int] = []
    var labels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lifeCounts = [20, 20]
        labels = [lifeCountLabel, lifeCountTwoLabel]
        displayLife(player: 0)
        displayLife(player: 1)
    }
    
    func displayLife(player: Int) {
        labels[player].text = "Life Count: \(lifeCounts[player])"
        playerResult()
    }
    
    func playerResult() {
        if lifeCounts[0] <= 0 {
            result.text = "Player 1 LOSES"
        } else if lifeCounts[1] <= 0 {
            result.text = "Player 2 LOSES"
        }
    }
    
    @IBAction func updateLifeCount(_ sender: UIButton) {
        var player: Int
        if (sender.accessibilityIdentifier == "p1") {
            player = 0
        } else {
            player = 1
        }
        var val = Int((sender.titleLabel?.text)!)
        lifeCounts[player] += val!
        displayLife(player: player)
    }
}

