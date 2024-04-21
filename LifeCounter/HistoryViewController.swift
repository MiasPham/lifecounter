//
//  HistoryViewController.swift
//  LifeCounter
//
//  Created by Mia Pham on 4/20/24.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var historyStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(historyStackView)
    }
    
    func showHistory(_ histories: [String]) {
        var history_labels: [UILabel] = []
        
        for history in histories {
            let label: UILabel = UILabel()
            label.text = history
            history_labels.append(label)
        }
        
        historyStackView = UIStackView(arrangedSubviews: history_labels)
        historyStackView.axis = .vertical
        historyStackView.spacing = 10
        historyStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyStackView)
        
        NSLayoutConstraint.activate([
            historyStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            historyStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            historyStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
