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
    
    let label = UILabel()
    let whenInUseThenAlwaysButton = UIButton()
    let whenInUseButton = UIButton()
    let alwaysButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.font = UIFont.systemFont(ofSize: 12.0)
        self.label.layer.borderColor = UIColor.lightGray.cgColor
        self.label.layer.borderWidth = 1.0
        self.view.addSubview(self.label)
        
        self.whenInUseThenAlwaysButton.setTitle("When In Use then Always", for: .normal)
        self.whenInUseThenAlwaysButton.addTarget(self, action: #selector(whenInUseThenAlways), for: .touchUpInside)
        self.whenInUseThenAlwaysButton.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.whenInUseThenAlwaysButton)
        
        self.whenInUseButton.setTitle("When In Use", for: .normal)
        self.whenInUseButton.addTarget(self, action: #selector(whenInUse), for: .touchUpInside)
        self.whenInUseButton.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.whenInUseButton)
        
        self.alwaysButton.setTitle("Always", for: .normal)
        self.alwaysButton.addTarget(self, action: #selector(always), for: .touchUpInside)
        self.alwaysButton.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.alwaysButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 16.0
        var top: CGFloat = self.topLayoutGuide.length + padding
        let itemWidth: CGFloat = self.view.frame.size.width - 2*padding
        let itemHeight: CGFloat = 40.0
        
        self.label.frame = CGRect(x: padding, y: top, width: itemWidth, height: itemHeight)
        top += itemHeight + padding
        
        self.whenInUseThenAlwaysButton.frame = CGRect(x: padding, y: top, width: itemWidth, height: itemHeight)
        top += itemHeight + padding
        
        self.whenInUseButton.frame = CGRect(x: padding, y: top, width: itemWidth, height: itemHeight)
        top += itemHeight + padding
        
        self.alwaysButton.frame = CGRect(x: padding, y: top, width: itemWidth, height: itemHeight)
        top += itemHeight + padding
    }
    
    @objc func whenInUseThenAlways() {
        self.label.text = "Requesting When In Use then Always..."
        _ = firstly {
            CLLocationManager.requestAuthorization(type: .whenInUse)
        }.then { _ in
            CLLocationManager.requestAuthorization(type: .always)
        }.done { _ in
            self.label.text = "Done"
        }
    }
    
    @objc func whenInUse() {
        self.label.text = "Requesting When In Use..."
        _ = firstly {
            CLLocationManager.requestAuthorization(type: .whenInUse)
        }.done { location in
            self.label.text = "Done"
        }
    }
    
    @objc func always() {
        self.label.text = "Requesting Always..."
        _ = firstly {
            CLLocationManager.requestAuthorization(type: .always)
        }.done { _ in
            self.label.text = "Done"
        }
    }

}

