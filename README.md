# PushManager

The Wraper around [Apple push notification](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html).

## Simple setup 

Just add `PushManager.swift` into your awesome project.

## Examples

#### setUp 

```swift 
// Use UIApplication's shared object `application`
PushManager.shared.set(pushFor: application) { (isGranted, token, error) in
    if error == nil {
        //Error while registering device            
        print("Error :- \(String(describing: error?.localizedDescription))")
        return
    }
    print("Device Token :- \(String(describing: token!)) and Permission :- \(String(describing: isgranted!))")
}
```

#### Device token(optional)

```swift
if let token = PushManager.shared.deviceToken {
    print(token)
}
```

#### Permition 

```swift
let permition = PushManager.shared.isPermitionGranted
print("Push notification :\(permition)")
```

#### Subscribe

```swift
// You can subscribe at any place using....
PushManager.shared.manager.subscribe { notificationData in
    print("Notification Data - \(notificationData)")
}
```

Issues
------

Feel free to submit issues and enhancement requests.

Contributing
------------

Please refer to each project's style guidelines and guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## License Summary

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
* 🍺
