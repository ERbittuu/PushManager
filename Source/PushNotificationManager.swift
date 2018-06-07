//
//  PushNotificationClass.swift
//  SamplePush
//
//  Created by Ketaki Damale on 18/04/18.
//  Copyright © 2018 Ketaki Damale. All rights reserved.
//

import UIKit
import UserNotifications

enum NOTIFICATION:String{
    case notificationRegister = "NotificationDidRegister"
    case notificationReceive = "NotificationDidRecive"
    case notificationFailedRegister = "NotificationDidFailedRegister"
    func stringValue() -> String {
        return self.rawValue
    }
}
//MARK: Push Notification Manager
class PushManager:NSObject
{
    //:Class Variable Declaration:
    var delegate:PushNotificationManagerDelegate?
    public var token:String? = nil
    public var isGranted:Bool = false
    static let shared = PushManager()
    var objRegisterCompletion : registerCompletion!
    var objReceiveCompletion : receiveCompletion!
    
    private override init() { }
    //:Typlealias
    typealias registerCompletion = (_ result: String?, _ error: Error? , _ isgranted: Bool?) -> Void
    typealias receiveCompletion = ([AnyHashable : Any]) -> Void
    
    //:init overloading:
    func setPushNotification(application: UIApplication,block:@escaping registerCompletion)
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
                      //  self.delegate?.applicationdidDeniedPermission(application)
                        block(nil,error,false)
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
                       // self.delegate?.applicationdidDeniedPermission(application)
                        block(nil,nil,false)
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
    func subscribe(completion:@escaping receiveCompletion)
    {
        self.objReceiveCompletion = completion
    }

}
extension PushManager
{
    func ApplicationDidRegisterWithdeviceToken(_ application:UIApplication,deviceToken:Data)
    {
        token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
      //  let DeviceInfo:[String: String] = ["deviceToken": token!]
         self.objRegisterCompletion(token!,nil,true)
        //fire notifcation
//        NotificationCenter.default.post(name: Notification.Name(NOTIFICATION.notificationRegister.stringValue()), object: nil, userInfo: DeviceInfo)
//        self.delegate?.applicationRegisteredDeviceToken(application, deviceToken: deviceToken)
    }
    func ApplicationdidFailedForRemoteNotification(_ application: UIApplication, error: Error)
    {
        self.objRegisterCompletion(nil,error,false)
//        NotificationCenter.default.post(name: Notification.Name(NOTIFICATION.notificationFailedRegister.stringValue()), object: nil, userInfo: nil)
//        self.delegate?.applicationDidFailedRegisteredDeviceToken(application,error: error)
    }
    func ApplicationReceivedRemoteNotification(_ application: UIApplication?,data: [AnyHashable : Any])
    {
        self.objReceiveCompletion(data)
//        NotificationCenter.default.post(name: Notification.Name(NOTIFICATION.notificationFailedRegister.stringValue()), object: nil, userInfo: data)
//        self.delegate?.applicationReceiveRemoteNotification(application, userInfo: data)
    }
    
}

