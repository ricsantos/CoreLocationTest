//
//  LocationFlowController.swift
//  CoreLocationTest
//
//  Created by Ricardo Santos on 10/5/18.
//  Copyright © 2018 Ricardo Santos. All rights reserved.
//

import Foundation
import CoreLocation

typealias AuthCompletion = (CLAuthorizationStatus) -> Void

enum RequestAuthorizationType {
    case always
    case whenInUse
}

class LocationFlowController: NSObject {
    
    private var manager = CLLocationManager()
    private var completion: AuthCompletion?
    private var haveRequestedAlways: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "Location.haveRequestedAlways")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Location.haveRequestedAlways")
        }
    }

    override init() {
        super.init()
        self.manager.delegate = self
        
        // Use this callback to check the current state, as when a system alert is presented to
        // ask the user for authorization, the app transitions to inactive and back.
        // This method is superior to the delegate as it will always be called.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func requestAuthorization(type: RequestAuthorizationType, completion: @escaping AuthCompletion) {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch type {
        case .always:
            switch status {
            case .notDetermined, .authorizedWhenInUse:
                if self.haveRequestedAlways {
                    completion(.authorizedWhenInUse)
                } else {
                    self.haveRequestedAlways = true
                    self.completion = completion
                    self.manager.requestAlwaysAuthorization()
                }
            default:
                completion(status)
            }
        case .whenInUse:
            switch status {
            case .notDetermined:
                self.completion = completion
                self.manager.requestWhenInUseAuthorization()
            default:
                completion(status)
            }
        }
    }
    
    @objc func applicationDidBecomeActive() {
        print("Application did become active")
        let status = CLLocationManager.authorizationStatus()
        print("Status: \(CLLocationManager.string(for: status))")
        if let completion = completion {
            self.completion = nil
            completion(status)
        }
    }
    
}

extension LocationFlowController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("LFC: Did change auth, status '\(CLLocationManager.string(for: status))'")
    }

}

extension CLLocationManager {
    
    static func string(for status: CLAuthorizationStatus) -> String {
        var statusString = "?"
        switch status {
        case .notDetermined:
            statusString = "Not Determined"
        case .restricted:
            statusString = "Restricted"
        case .denied:
            statusString = "Denied"
        case .authorizedWhenInUse:
            statusString = "Authorized When In Use"
        case .authorizedAlways:
            statusString = "Authorized Always"
        }
        return statusString
    }
    
}

