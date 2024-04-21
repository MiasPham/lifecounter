//
//  ViewController.swift
//  LifeCounter
//
//  Created by Mia Pham on 4/15/24.
//

import UIKit

extension String {
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits
        return CharacterSet(charactersIn: self).isSubset(of: characters)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    var lifeCounts: [Int] = []
    var labels: [UILabel] = []
    var lifeInputs: [UITextField] = []
    var addPlayerBtn = UIButton(type: .roundedRect)
    var histories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addPlayerBtn.setTitle("Add player", for: .normal)
        addPlayerBtn.tag = 1
//        addBtn.frame = coords[((num-1) / 3)][((num-1) % 3)]
        addPlayerBtn.frame = CGRect(x: 39, y: 59, width:75 , height:39)
        addPlayerBtn.layer.cornerRadius = 10
        
        self.view.addSubview(addPlayerBtn)
        
        addPlayerBtn.addTarget(self, action: #selector(addPlayer(_:)), for: .touchUpInside)
        
        for i in 1...4 {
            addPlayer(addPlayerBtn)
        }
    }
    
    var playerCount = 0
    var playerStackView: UIStackView!
    
    @IBAction func showHistory(_ sender: UIButton) {
        var historyViewController = self.storyboard!.instantiateViewController(withIdentifier: "history_view") as! HistoryViewController
        historyViewController.showHistory(histories)
        self.present(historyViewController, animated: true, completion: nil)
    }
    
    @IBAction func addPlayer(_ sender: UIButton) {
        let playerLabel = UILabel()
        playerLabel.text = "Player \(playerCount + 1)"
        playerLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
        let lifeCountLabel = UILabel()
        lifeCountLabel.text = "Life Count: 20"
        lifeCountLabel.font = UIFont.systemFont(ofSize: 16)
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Number"
        
        labels.append(lifeCountLabel)
        lifeCounts.append(20)
        lifeInputs.append(inputTextField)
        
        let addBtn = UIButton(type: .roundedRect)
        addBtn.setTitle("+", for: .normal)
        addBtn.accessibilityIdentifier = String(playerCount) + "+"
        addBtn.addTarget(self, action: #selector(updateLifeCount(_:)), for: .touchUpInside)
        
        let minusBtn = UIButton(type: .roundedRect)
        minusBtn.setTitle("-", for: .normal)
        minusBtn.accessibilityIdentifier = String(playerCount) + "-"
        minusBtn.addTarget(self, action: #selector(updateLifeCount(_:)), for: .touchUpInside)
        
        let buttonStackView = UIStackView(arrangedSubviews: [lifeCountLabel, minusBtn, inputTextField, addBtn])
        buttonStackView.axis = .horizontal
        
        let playerInfoStackView = UIStackView(arrangedSubviews: [playerLabel, buttonStackView])
        playerInfoStackView.axis = .vertical
        playerInfoStackView.alignment = .center
        playerInfoStackView.spacing = 5
        
        if playerCount == 0 {
            playerStackView = UIStackView(arrangedSubviews: [playerInfoStackView])
            playerStackView.axis = .vertical
            playerStackView.spacing = 10
            playerStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(playerStackView)
            
            NSLayoutConstraint.activate([
                playerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                playerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                playerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ])
        } else {
            playerStackView.addArrangedSubview(playerInfoStackView)
        }
        
        playerCount += 1
        if playerCount > 7 {
            addPlayerBtn.isEnabled = false
        }
    }
    
    func displayLife(player: Int) {
        labels[player].text = "Life Count: \(lifeCounts[player])"
        playerResult(player: player)
    }
    
    func playerResult(player: Int) {
//        if lifeCounts[0] <= 0 {
//            result.text = "Player 1 LOSES"
//        } else if lifeCounts[1] <= 0 {
//            result.text = "Player 2 LOSES"
//        }
        if lifeCounts[player] <= 0 {
            result.text = "Player \(player + 1) LOSES"
        }
    }
    
    //Still need to update this to receive numbers only
    @IBAction func updateLifeCount(_ sender: UIButton) {
        let playerStr = (sender.accessibilityIdentifier)!.prefix(1)
        let player: Int = Int(playerStr)!
        
        var sign = 1
        
        if (sender.accessibilityIdentifier!.contains("-")) {
            sign = -1
        }
        
        let lifeChangeText = lifeInputs[player].text!
        var lifeChange = 1
        
//        print(lifeChangeText)
        if (lifeChangeText != "" && lifeChangeText.isNumber) {
            lifeChange = Int(lifeChangeText)!
        } else if (lifeChangeText != "") {
            let alertController = UIAlertController(title: "Error Input", message: "Please Input Number Only", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK!", style: .default, handler: nil)
            alertController.addAction(alertAction)

            // Present UIAlertController
            present(alertController, animated: true, completion: nil)
            lifeInputs[player].text = ""
            return
        }
        
        // Read the life change amount from the text field
        var previousLife = lifeCounts[player]
        lifeCounts[player] += sign  * lifeChange
        
        var recordStr = "Player \(player + 1) has "
        
        if (previousLife < lifeCounts[player]) {
            histories.append(recordStr + "increased by \(lifeCounts[player] - previousLife)")
        } else {
            histories.append(recordStr + "decreased by \(-lifeCounts[player] + previousLife)")
        }
        
        addPlayerBtn.isEnabled = false
        displayLife(player: player)
        // Clear the text field after updating
        lifeInputs[player].text = ""
    }

}

