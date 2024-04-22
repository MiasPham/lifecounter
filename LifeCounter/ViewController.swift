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
    var playerNames: [UILabel] = []
    var addPlayerBtn = UIButton(type: .roundedRect)
    var histories: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addPlayerBtn.setTitle("Add player", for: .normal)
        addPlayerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addPlayerBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addPlayerBtn)
        
        NSLayoutConstraint.activate([
            addPlayerBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
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
        let historyViewController = self.storyboard!.instantiateViewController(withIdentifier: "history_view") as! HistoryViewController
        historyViewController.showHistory(histories)
        self.present(historyViewController, animated: true, completion: nil)
    }
    
    @IBAction func addPlayer(_ sender: UIButton) {
        let playerLabel = UILabel()
        playerLabel.text = "Player \(playerCount + 1)"
        playerLabel.font = UIFont.boldSystemFont(ofSize: 15)
        playerNames.append(playerLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerNameTapped(_:)))
        playerLabel.isUserInteractionEnabled = true
        playerLabel.addGestureRecognizer(tapGesture)
        playerLabel.tag = playerCount
        
        let lifeCountLabel = UILabel()
        lifeCountLabel.text = "Life Count: 20"
        lifeCountLabel.font = UIFont.systemFont(ofSize: 15)
        
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
        
        let playerInfoStackView = UIStackView(arrangedSubviews: [playerLabel, lifeCountLabel, minusBtn, inputTextField, addBtn])
        playerInfoStackView.axis = .horizontal
        playerInfoStackView.alignment = .center
        playerInfoStackView.spacing = 3
        
        if playerCount == 0 {
            playerStackView = UIStackView()
            playerStackView.axis = .vertical
            playerStackView.spacing = 8
            playerStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(playerStackView)
            
            NSLayoutConstraint.activate([
                playerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                playerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
                playerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
            ])
        }
        
        playerStackView.addArrangedSubview(playerInfoStackView)
        
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
        let playerName = playerNames[player].text!
        if lifeCounts[player] <= 0 {
            result.text = "\(playerName) LOSES"
        }
    }
    
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
            
            present(alertController, animated: true, completion: nil)
            lifeInputs[player].text = ""
            return
            
        }
        
        // Read the life change amount from the text field
        let previousLife = lifeCounts[player]
        lifeCounts[player] += sign  * lifeChange
        
        let recordStr = playerNames[player].text!
        
        if (previousLife < lifeCounts[player]) {
            histories.append(recordStr + " has increased by \(lifeCounts[player] - previousLife)")
        } else {
            histories.append(recordStr + " has decreased by \(-lifeCounts[player] + previousLife)")
        }
        
        addPlayerBtn.isEnabled = false
        displayLife(player: player)
        
        // Clear the text field after updating
        lifeInputs[player].text = ""
        
        checkGameOver()
    }
    
    //EC: Game over and return the game to the OG state
    func checkGameOver() {
        var playersLeft = 0
        var lastPlayerIndex = -1
        for (index, lifeCount) in lifeCounts.enumerated() {
            if lifeCount > 0 {
                playersLeft += 1
                lastPlayerIndex = index
            }
        }
        if playersLeft == 1 {
            displayGameOver(lastPlayerIndex: lastPlayerIndex)
        }
    }
    
    func displayGameOver(lastPlayerIndex: Int) {
        let alertController = UIAlertController(title: "Game over!", message: "Player \(lastPlayerIndex + 1) wins!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Reset back to the original application state
            self?.resetGame()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //EC: Add reset button
    @IBAction func resetButton(_ sender: UIButton) {
        resetGame()
    }
    
    func resetGame() {
        lifeCounts.removeAll()
        labels.removeAll()
        lifeInputs.removeAll()
        histories.removeAll()
        playerNames.removeAll()
        playerCount = 0
        
        removeAllStackViews()
        
        for _ in 1...4 {
            addPlayer(addPlayerBtn)
        }
        
        result.text = ""
        // Enable addPlayerBtn
        addPlayerBtn.isEnabled = true
    }
    
    func removeAllStackViews() {
        for subview in view.subviews {
            if let stackView = subview as? UIStackView {
                stackView.removeFromSuperview()
            }
        }
    }
    
    
    //EC: Change player's name
    @objc func playerNameTapped(_ sender: UITapGestureRecognizer) {
        guard let playerLabel = sender.view as? UILabel else { return }
        
        let alertController = UIAlertController(title: "Enter New Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "New Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newName = alertController.textFields?.first?.text else { return }
            playerLabel.text = newName
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

