//
//  ViewController.swift
//  CardsWarGame
//
//  Created by Student29 on 13/06/2023.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var inserNameButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelButton: UILabel!
    @IBOutlet weak var westSideLabel: UILabel!
    @IBOutlet weak var eastSideLabel: UILabel!
    
    var homeManager = HomeManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eastSideLabel.isHidden = true
        westSideLabel.isHidden = true
        
        locationManager.delegate = self
        homeManager = HomeManager(delegate: self, model: HomeModel())
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        if let name = UserDefaults.standard.string(forKey: "name") {
            DispatchQueue.main.async {
                self.nameLabel.text = "Hi, \(name)"
                self.inserNameButton.isHidden = true
                self.homeManager.model?.name = name
            }
        }
    }
    
    
    @IBAction func inserName(_ sender: Any) {
        let alertController = UIAlertController(title: "Insert Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = self.homeManager.model?.name ?? "Name"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let textField = alertController.textFields?.first else { return }
            let enteredText = textField.text ?? ""
            self.nameLabel.text = "Hi, \(enteredText)"
            self.inserNameButton.isHidden = true
            self.homeManager.model?.name = enteredText
            
            UserDefaults.standard.set(enteredText, forKey: "name")
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        homeManager.performChecks()
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.view.alpha = 0.7
        alertController.view.layer.cornerRadius = 15
        present(alertController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alertController.dismiss(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToGame" {
            if let destinationVC = segue.destination as? GameViewController {
                destinationVC.isEast = self.homeManager.isEast()
                destinationVC.playerName = self.homeManager.model?.name
            }
        }
    }
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.requestLocation()
                break
            case .notDetermined, .denied, .restricted:
                break
            default: break
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            homeManager.model?.lat = lat
            homeManager.model?.lon = lon
            print("lat=\(lat) lon=\(lon)")
            
            DispatchQueue.main.async {
                self.eastSideLabel.isHidden = !self.homeManager.isEast()
                self.westSideLabel.isHidden = self.homeManager.isEast()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension HomeViewController : HomeManagerDelegate {
    
    func didPassChecks() {
        self.performSegue(withIdentifier: "navigateToGame", sender: self)
    }
    
    func didFailChecks(errorType: Int) {
        switch(errorType) {
            case 0:
                showToast(message: "Please make sure you insert name in order to start game.")
                break;
            case 1:
                showToast(message: "Please make sure you enabled location services and wait for location to be received.")
                locationManager.requestLocation()
                break;
            default:
                break;
        }
    }
}

