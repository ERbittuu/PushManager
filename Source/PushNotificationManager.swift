//
//  PushNotificationClass.swift
//  SamplePush
//
//  Created by Ketaki Damale on 18/04/18.
//  Copyright © 2018 Ketaki Damale. All rights reserved.
//

import UIKit
import UserNotifications

//MARK: Push Notification Manager
class PushManager:NSObject
{
    //:Class Variable Declaration:
    public var token:String? = nil
    public var isGranted:Bool = false
    static let shared = PushManager()
    private var objRegisterCompletion : Register!
    private var objReceiveCompletion : [Receive?] = []
    private override init() { }
    //:Typlealias
    typealias Register = (_ isgranted: Bool,_ token: String?, _ error: Error?) -> Void
    typealias Receive  = ([AnyHashable : Any]) -> Void
    
    func set(_PushFor application: UIApplication,block:@escaping Register)
    {
        if #available(iOS 10, *)
        {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            { (granted, error) in
                guard error == nil else
                {
                   //:Delgate call:
                    DispatchQueue.main.async
                    {
                        block(false,nil,error)
                    }
                    return
                }
                self.isGranted = granted
                if granted
                {
                    //:Application register for Push Notification:
                    DispatchQueue.main.async
                    {
                        application.registerForRemoteNotifications()
                         self.objRegisterCompletion = block
                    }
                }
                else
                {
                  //:Delgate call:
                    DispatchQueue.main.async
                    {
                        block(false,nil,nil)
                    }
                    return
                }
            }
        }
        else
        {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            self.objRegisterCompletion = block
        }
       
    }
    func subscribe(completion:@escaping Receive)
    {
        self.objReceiveCompletion.append(completion)
    }

}
extension PushManager
{
    func ApplicationDidRegisterWithdeviceToken(_ application:UIApplication,deviceToken:Data)
    {
        token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
         self.objRegisterCompletion(true,token!,nil)
    }
    func ApplicationdidFailedForRemoteNotification(_ application: UIApplication, error: Error)
    {
        self.objRegisterCompletion(false,nil,error)
    }
    func ApplicationReceivedRemoteNotification(_ application: UIApplication?,data: [AnyHashable : Any])
    {
        for ref  in self.objReceiveCompletion {
            ref!(data)
        }
    }
}
//MARK: AppDelegate Extension
extension AppDelegate
{
    //Degelate call
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        PushManager.shared.ApplicationDidRegisterWithdeviceToken(application, deviceToken: deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        PushManager.shared.ApplicationdidFailedForRemoteNotification(application, error: error)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any])
    {
        PushManager.shared.ApplicationReceivedRemoteNotification(application,data: data)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void)
    {
        PushManager.shared.ApplicationReceivedRemoteNotification(nil,data: notification.request.content.userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        PushManager.shared.ApplicationReceivedRemoteNotification(nil,data: response.notification.request.content.userInfo)
    }
}


