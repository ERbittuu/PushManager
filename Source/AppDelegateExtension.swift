//
//  AppDelegateExtension.swift
//  SamplePush
//
//  Created by Ketaki Damale on 19/04/18.
//  Copyright © 2018 Ketaki Damale. All rights reserved.
//

import UIKit
import UserNotifications

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
