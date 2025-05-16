//
//  LocationSelectionViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/2/25.
//
import UIKit
import SwiftUI

class ConsumableShopData: ObservableObject {
    @Published var coffee: Bool = false
    @Published var spaceBait: Int = 0
}

/// View controller that displays a list of fishing locations for user selection. Bars access to a location if the user doesn't meet minimum requirements.
class LocationSelectionViewController: UIViewController {

    let shopData = ConsumableShopData()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var whereToLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DynamicTypeFontHelper().applyDynamicFont(fontName: "Futura-CondensedExtraBold", size: 38, textStyle: .largeTitle, to: whereToLabel)
    }
    
    @IBAction func consumableItemShopButtonPressed(_ sender: Any) {
        // shopData is now a persistent property of the class
        let swiftUIView = ConsumableItemsShop(
//            coffee: Binding(get: { self.shopData.coffee }, set: { self.shopData.coffee = $0 }),
//            spaceBait: Binding(get: { self.shopData.spaceBait }, set: { self.shopData.spaceBait = $0 })
        )
        let hostingController = UIHostingController(rootView: swiftUIView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBSegueAction func goToLocation(_ coder: NSCoder, sender: Any?) -> FishingScreenViewController? {
        SoundManager.shared.playSound(sound: .bubble3)
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
        if location.requiredLicense.rawValue <= TackleboxService.shared.tacklebox.fishingLicense.rawValue {
            performSegue(withIdentifier: "goToLocationSegue", sender: indexPath)
        }
    }
    
    @IBAction func unwindToLocationSelection(_ unwindSegue: UIStoryboardSegue) {

    }
}
