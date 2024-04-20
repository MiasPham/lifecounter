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
    @IBOutlet weak var lifeInput: UITextField!
    @IBOutlet weak var lifeInputTwo: UITextField!
    
    
    var lifeCounts: [Int] = []
    var labels: [UILabel] = []
    var lifeInputs: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        lifeCounts = [20, 20]
//        labels = [lifeCountLabel, lifeCountTwoLabel]
//        lifeInputs = [lifeInput, lifeInputTwo]
//        displayLife(player: 0)
//        displayLife(player: 1)
//        
//        let button = UIButton()
//        button.addTarget(self,
//            action: #selector(ViewController.buttonPressed(sender:)),
//            for: .touchUpInside)
//        self.view.addSubview(button)
        
//        self.view.addSubview(mainView)
        
        var addBtn = UIButton(type: .roundedRect)
        addBtn.setTitle("Add player", for: .normal)
        addBtn.tag = 1
//        addBtn.frame = coords[((num-1) / 3)][((num-1) % 3)]
        addBtn.frame = CGRect(x: 39, y: 59, width:75 , height:39)
        addBtn.layer.cornerRadius = 10
        
        self.view.addSubview(addBtn)
        
        addBtn.addTarget(self, action: #selector(addPlayer(_:)), for: .touchUpInside)
    }
    
    var playerCount = 0
    var playerStackView: UIStackView!
    
    @IBAction func addPlayer(_ sender: UIButton) {
        let playerLabel = UILabel()
        playerLabel.text = "Player \(playerCount + 1)"
        playerLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
        let lifeCountLabel = UILabel()
        lifeCountLabel.text = "Life: 20"
        lifeCountLabel.font = UIFont.systemFont(ofSize: 16)
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Number"
        
        labels.append(lifeCountLabel)
        lifeCounts.append(20)
        lifeInputs.append(inputTextField)
        
        var addBtn = UIButton(type: .roundedRect)
        addBtn.setTitle("+", for: .normal)
        addBtn.accessibilityIdentifier = String(playerCount) + "+"
        addBtn.addTarget(self, action: #selector(updateLifeCount(_:)), for: .touchUpInside)
        
        var minusBtn = UIButton(type: .roundedRect)
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
    }
    
    func displayLife(player: Int) {
        labels[player].text = "Life Count: \(lifeCounts[player])"
        playerResult()
    }
    
    func playerResult() {
//        if lifeCounts[0] <= 0 {
//            result.text = "Player 1 LOSES"
//        } else if lifeCounts[1] <= 0 {
//            result.text = "Player 2 LOSES"
//        }
    }
    
    //Still need to update this to receive numbers only
    @IBAction func updateLifeCount(_ sender: UIButton) {
        var playerStr = (sender.accessibilityIdentifier)!.prefix(1)
        var player: Int = Int(playerStr)!
        
        var sign = 1
        
        if (sender.accessibilityIdentifier!.contains("-")) {
            sign = -1
        }
        
        let lifeChangeText = lifeInputs[player].text!
        var lifeChange = 1
        
//        print(lifeChangeText)
        if (lifeChangeText != "") {
            lifeChange = Int(lifeChangeText)!
        }
        
        // Read the life change amount from the text field
        lifeCounts[player] += sign  * lifeChange
        displayLife(player: player)
        // Clear the text field after updating
        lifeInputs[player].text = ""
        }
}

