//
//  ViewController.swift
//  LifeCounter
//
//  Created by Mia Pham on 4/15/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLifeCount()
        updateLifeCount2()
    }

    @IBOutlet weak var lifeCount: UILabel!
    var count = 20
    
    func updateLifeCount() {
        lifeCount.text = "Life Count: \(count)"
        playerResult()
    }
    
    @IBAction func addLife(_ sender: Any) {
        count += 1
        updateLifeCount()
    }
    
    @IBAction func removeLife(_ sender: Any) {
        count -= 1
        updateLifeCount()
    }
    
    @IBAction func addFiveLife(_ sender: Any) {
        count += 5
        updateLifeCount()
    }
    
    @IBAction func removeFiveLife(_ sender: Any) {
        count -= 5
        updateLifeCount()
    }
    
    //Player 2
    @IBOutlet weak var lifeCountTwo: UILabel!
    var count2 = 20
    
    func updateLifeCount2() {
        lifeCountTwo.text = "Life Count: \(count2)"
        playerResult()
    }
    
    @IBAction func addLifeTwo(_ sender: Any) {
        count2 += 1
        updateLifeCount2()
    }
    
    @IBAction func removeLifeTwo(_ sender: Any) {
        count2 -= 1
        updateLifeCount2()
    }
    
    @IBAction func addFiveLifeTwo(_ sender: Any) {
        count2 += 5
        updateLifeCount2()
    }
    
    @IBAction func removeFiveLifeTwo(_ sender: Any) {
        count2 -= 5
        updateLifeCount2()
    }
    
    @IBOutlet weak var result: UILabel!
    
    func playerResult() {
        if count <= 0 {
            result.text = "Player 1 LOSES"
        } else if count2 <= 0 {
            result.text = "Player 2 LOSES"
        }
    }
}

