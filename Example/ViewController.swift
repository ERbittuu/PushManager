//
//  ViewController.swift
//  SamplePush
//
//  Created by Ketaki Damale on 18/04/18.
//  Copyright © 2018 Ketaki Damale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = PushManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNotification()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getNotification() {
        if manager.isGranted{
                manager.subscribe { (data) in
                    print("Notification Data - \(data)")
                }
        }
    }
}

