//
//  SummaryScreenViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/18/25.
//

import UIKit

/// View controller that shows each each fish caught and how much money the user made that day.
class SummaryScreenViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var caughtItems: [CaughtItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self

        let backgroundView = UIImageView(image: UIImage(named: "boat"))
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.alpha = 0.5
        tableView.backgroundView = backgroundView
    }
    @IBAction func doneButton(_ sender: Any) {
        SoundManager.shared.playSound(sound: .bubble2)
    }
}

extension SummaryScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return caughtItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Once every fish has been displayed, a cell summarizing the total value of all caught fish is displayed
        if indexPath.section <= caughtItems.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CaughtFishCell") as! CaughtFishTableViewCell
            
            let item = caughtItems[indexPath.section]
            
            switch item {
            case .fish(let fish):
                cell.setFish(fish: fish)
            case .junk(let junk):
                cell.setJunk(junk: junk)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellTotalCell") as! SellTotalTableViewCell
            let total = caughtItems.reduce(0) {$0 + $1.price}
            
            let totalPrice = total.formatted(.currency(code: "USD"))
            cell.setTotal(totalPrice)
            
            return cell
        }
    }
}
