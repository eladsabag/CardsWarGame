//
//  ViewController.swift
//  CardsWarGame
//
//  Created by Student29 on 13/06/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var inserNameButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelButton: UILabel!
    
    var gameManager = GameManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        gameManager.delegate = self
        
        handlePermissions()
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.nameLabel.text = "Hi, \(name)"
            self.gameManager.model?.name = name
            self.inserNameButton.isHidden = true
        }
    }
    
    
    @IBAction func inserName(_ sender: Any) {
        let alertController = UIAlertController(title: "Insert Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = self.gameManager.model?.name ?? "Name"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let textField = alertController.textFields?.first else { return }
            let enteredText = textField.text ?? ""
            self.nameLabel.text = "Hi, \(enteredText)"
            self.gameManager.model?.name = enteredText
            self.inserNameButton.isHidden = true
            
            UserDefaults.standard.set(enteredText, forKey: "name")
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        gameManager.performChecks()
    }
    
    func handlePermissions() {
        if CLLocationManager.locationServicesEnabled() {
            switch (CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.requestLocation()
                @unknown default:
                    break
                }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            gameManager.model?.lat = lat
            gameManager.model?.lon = lon
            print("lat=\(lat) lon=\(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController : GameManagerDelegate {
    
    func didPassChecks() {
        
    }
    
    func didFailChecks(errorType: Int, message: String) {
        switch(errorType) {
            case 0:
                handlePermissions()
                break;
            case 1:
                break;
            default:
                break;
        }
        showToast(message: message)
    }
}

