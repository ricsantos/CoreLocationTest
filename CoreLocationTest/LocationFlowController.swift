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
    
    override init() {
        super.init()
        self.manager.delegate = self
    }
    
    func requestAuthorization(type: RequestAuthorizationType, completion: @escaping AuthCompletion) {
        guard self.completion == nil else { fatalError() }
        self.completion = completion
        switch type {
        case .always:
            self.manager.requestAlwaysAuthorization()
        case .whenInUse:
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
}

extension LocationFlowController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("LFC: Did change auth, status '\(CLLocationManager.string(for: status))'")
        if let completion = self.completion {
            completion(status)
            self.completion = nil
        }
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

