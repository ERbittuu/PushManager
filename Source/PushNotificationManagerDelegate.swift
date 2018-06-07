//
//  PushNotificationManagerDelegate.swift
//  SamplePush
//
//  Created by Ketaki Damale on 19/04/18.
//  Copyright © 2018 Ketaki Damale. All rights reserved.
//

import UIKit

//MARK: Push Notification Protocol
protocol PushNotificationManagerDelegate
{
    //:Callback Method For Registered Device Token:
    func applicationRegisteredDeviceToken(_ application: UIApplication, deviceToken: Data?);
    
    //:Callback Method For Receiveing Remote Notification:
    func applicationReceiveRemoteNotification(_ application: UIApplication?, userInfo: [AnyHashable : Any]);
    
    //:Callback Method For Denined Permission:
    func applicationdidDeniedPermission(_ application:UIApplication);
    
    //:Callback Method For Failed Device Registration:
    func applicationDidFailedRegisteredDeviceToken(_ application: UIApplication, error: Error);
}

extension PushNotificationManagerDelegate
{
    func applicationdidDeniedPermission(_ application:UIApplication)
    {
        
    }
    func applicationRegisteredDeviceToken(_ application: UIApplication, deviceToken: Data?)
    {
        
    }
    func applicationDidFailedRegisteredDeviceToken(_ application: UIApplication, error: Error)
    {
        
    }
}
