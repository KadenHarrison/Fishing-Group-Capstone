//
//  SummaryScreenViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/18/25.
//

import UIKit

class SummaryScreenViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var caughtFish: [Fish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self

        let backgroundView = UIImageView(image: UIImage(named: "boat"))
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.alpha = 0.5
        tableView.backgroundView = backgroundView
    }
}

extension SummaryScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return caughtFish.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section <= caughtFish.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CaughtFishCell") as! CaughtFishTableViewCell
            
            let fish = caughtFish[indexPath.section]
            
            cell.setFish(fish: fish)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellTotalCell") as! SellTotalTableViewCell
            let total = caughtFish.reduce(0) { $0 + $1.price }
            
            let totalPrice = total.formatted(.currency(code: "USD"))
            cell.setTotal(totalPrice)
            
            return cell
        }
    }
}
