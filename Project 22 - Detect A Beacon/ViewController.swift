//
//  ViewController.swift
//  Project 22 - Detect A Beacon
//
//  Created by Sean Williams on 31/10/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    
    
    var locationManager: CLLocationManager?
    var beaconDetected = false
    let beaconsArray = ["5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", "74278BDA-B644-4520-8F0C-720EAF059935"]
    var circleView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
                
        circleView = UIView(frame: CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 256, height: 256))
        circleView.center = view.center
        circleView.backgroundColor = .black
        circleView.layer.cornerRadius = 128
        view.addSubview(circleView)
        
        
        beaconDetected = false
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning(for: "MyBeacon", uuid: beaconsArray[0])
                    startScanning(for: "Apple Air Locate 1", uuid: beaconsArray[1])
                    startScanning(for: "Apple Air Locate 2", uuid: beaconsArray[2])
                }
            }
        }
    }

    func startScanning(for beaconNamed: String, uuid: String) {
        let uuid = UUID(uuidString: uuid)!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: beaconNamed)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
      
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "IMMEDIATE"
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconName.text = "No Beacon Detected"
                self.circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            
            if beacon.uuid.description == beaconsArray[0] {
                beaconName.text = "My Beacon"
            } else if beacon.uuid.description == beaconsArray[1]{
                beaconName.text = "Apple Air Locate 1"
            } else if beacon.uuid.description == beaconsArray[2]{
                beaconName.text = "Apple Air Locate 2"
            } else {
                beaconName.text = "No Beacon Detected"
            }
            
            if beaconDetected == false {
                let ac = UIAlertController(title: "ALERT", message: "iBeacon Detected", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
                
                beaconDetected = true
            }
        }
//        } else {
//            update(distance: .unknown)
//        }
    }
}

