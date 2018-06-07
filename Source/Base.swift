//
//  Base.swift
//  SamplePush
//
//  Created by Ketaki Damale on 24/05/18.
//  Copyright © 2018 Ketaki Damale. All rights reserved.
//

import UIKit

class Base: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidRegisterNotification(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.notificationRegister.stringValue()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidFailedRegisterNotification(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.notificationFailedRegister.stringValue()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidReceiveNotification(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.notificationReceive.stringValue()), object: nil)
    }
    @objc func DidRegisterNotification(notification: Notification){
        
    }
    @objc func DidFailedRegisterNotification(notification: Notification){
        
    }
    @objc func DidReceiveNotification(notification: Notification){
        
    }
    
}
