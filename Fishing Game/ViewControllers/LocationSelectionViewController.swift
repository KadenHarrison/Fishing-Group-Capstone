//
//  LocationSelectionViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/2/25.
//
// THIS WOEKDED
import UIKit

/// View controller that displays a list of fishing locations for user selection. Bars access to a location if the user doesn't meet minimum requirements.
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
        
        let location = AllLocations.allCases[indexPath.row].location
        
        fishingScreenViewController?.fishingDay.location = location
        
        return fishingScreenViewController
    }
}

// MARK: LocationsTableView

extension LocationSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllLocations.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as? LocationTableViewCell else { fatalError("Dequeue failed!")
        }
        
        let location = AllLocations.allCases[indexPath.row].location
        
        cell.configureCell(for: location)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let location = AllLocations.allCases[indexPath.row].location
        
        // User must meet minimum license requirements to call performSegue
        if location.requiredLicense.rawValue <= Tacklebox.shared.fishingLicense.rawValue {
            performSegue(withIdentifier: "goToLocationSegue", sender: indexPath)
        }
    }
    
    @IBAction func unwindToLocationSelection(_ unwindSegue: UIStoryboardSegue) {

    }
}
