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
    private var registerObject : Register!
    private var receiveObject : [Receive?] = []
    private override init() { }
    //:Typlealias
    typealias Register = (_ isgranted: Bool,_ token: String?, _ error: Error?) -> Void
    typealias Receive  = ([AnyHashable : Any]) -> Void
    
    ///Used to instantiate the PUSH Notification object.This method is a public method and accepts single parameter of type [UIApplication](https://developer.apple.com/documentation/uikit/uiapplication) Your singleton app object. This method is used to register push notification.for version greater than 10.0 it uses [UNUserNotificationCenter](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter).
    ///
    ///It is recomanded to use it in appDeleagte inside [didFinishLaunchingWithOptions](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application). The clouser returns user permission,Device token and Error.
    ///- parameter application: Singlton app object.This object is required to register the Push notification object for app.
    /// - parameter block : The **Register** type block is a clouser having three paramters **isgranted**,**token** and **error** with data type **Bool**,**String** and **Error** respectively.
    public func set(_PushFor application: UIApplication,block:@escaping Register)
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
                         self.registerObject = block
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
            self.registerObject = block
        }
       
    }
    
    ///This method is defined to handle the notification.It is a public method and can be used with **PushManager** singlton object.This method returns the clouser when [didReceiveRemoteNotification](https://developer.apple.com/documentation/watchkit/wkextensiondelegate/1628170-didreceiveremotenotification) is called.
    ///
    ///If the app is running, the app calls this method to process incoming remote notifications.
    /// - parameter completion : The **Receive** type block is a clouser having single paramter.This returns the notification data sent from server.
    public func getNotification(_ completion:@escaping Receive)
    {
        self.receiveObject.append(completion)
    }

}
extension PushManager
{
    fileprivate func ApplicationDidRegisterWithdeviceToken(_ application:UIApplication,deviceToken:Data)
    {
        token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
         self.registerObject(true,token!,nil)
    }
    fileprivate func ApplicationdidFailedForRemoteNotification(_ application: UIApplication, error: Error)
    {
        self.registerObject(false,nil,error)
    }
    fileprivate func ApplicationReceivedRemoteNotification(_ application: UIApplication?,data: [AnyHashable : Any])
    {
        for ref  in self.receiveObject {
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


