//
//  LocationSelectionViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/2/25.
//
//THIS IS SUPPOSED TO WORK!!!!!!!!!
import UIKit

class LocationSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBSegueAction func goToLocation(_ coder: NSCoder, sender: Any?) -> FishingScreenViewController? {
        let fishingScreenViewController = FishingScreenViewController(coder: coder)
        
        guard let indexPath = sender as? IndexPath else {
            fatalError("Failed to cast sender as index path in LocationSelectionViewController.goToLocation(_:sender:)")
        }
        
        let location = Location.list[indexPath.row]
        
        fishingScreenViewController?.location = location
        
        return fishingScreenViewController
    }
}

extension LocationSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Location.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as? LocationTableViewCell else { fatalError("Dequeue failed!")
        }
        
        let location = Location.list[indexPath.row]
        
        cell.configureCell(for: location)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let location = Location.list[indexPath.row]
        
        if location.requiredLicense.rawValue <= Tacklebox.shared.fishingLicense.rawValue {
            performSegue(withIdentifier: "goToLocationSegue", sender: indexPath)
        }
    }
    
    @IBAction func unwindToLocationSelection(_ unwindSegue: UIStoryboardSegue) {

    }
}
