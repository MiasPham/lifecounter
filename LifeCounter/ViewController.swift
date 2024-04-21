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
        addPlayerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        addPlayerBtn.frame = CGRect(x: 30, y: 60, width:90 , height:39)
        addPlayerBtn.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(addPlayerBtn)
        
        NSLayoutConstraint.activate([
                addPlayerBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
                addPlayerBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
                addPlayerBtn.widthAnchor.constraint(equalToConstant: 90),
                addPlayerBtn.heightAnchor.constraint(equalToConstant: 39)
            ])
        
        addPlayerBtn.addTarget(self, action: #selector(addPlayer(_:)), for: .touchUpInside)

        for _ in 1...4 {
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
        playerInfoStackView.spacing = 3
        
        
        if playerCount == 0 {
            playerStackView = UIStackView(arrangedSubviews: [playerInfoStackView])
            playerStackView.axis = .vertical
//            playerStackView.distribution = .fillEqually
            playerStackView.spacing = 20
            playerStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(playerStackView)
            
            NSLayoutConstraint.activate([
                playerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                playerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                playerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
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

