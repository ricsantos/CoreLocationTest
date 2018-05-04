//
//  ViewController.swift
//  CoreLocationTest
//
//  Created by Ric Santos on 5/5/18.
//  Copyright © 2018 Ricardo Santos. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = firstly {
            CLLocationManager.requestAuthorization(type: .whenInUse)
        }.then { _ in
            CLLocationManager.requestLocation()
        }.then { _ in
            CLLocationManager.requestAuthorization(type: .always)
        }.done { _ in
            print("tada")
        }
    }

}

