//
//  NotificationServices.swift
//  Restaurant
//
//  Created by hosam on 9/12/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationServices {
    
    static let notificationServices = NotificationServices()
    
    func scheduleNotification(restaurants:[Restaurant],completionHandler: @escaping (Error?)->Void)  {
        
        if restaurants.count <= 0 {
            return
        }
        
        // Pick a restaurant randomly
        
        let randomNum = Int.random(in: 0 ..< restaurants.count)
        let suggestedRestaurant = restaurants[randomNum]
        
        // Create the user notification
        let content = UNMutableNotificationContent()
        content.title = "Restaurant Recommendation"
        content.subtitle = "Try new food today"
        content.body = "I recommend you to check out \(suggestedRestaurant.name!). The restaurant is one of your favorites. It is located at \(suggestedRestaurant.location!). Would you like to give it a try?"
        content.sound = UNNotificationSound.default
        content.userInfo = ["phone": suggestedRestaurant.phone!]
        
        
        
        
        // Add an image to the notification
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
        
        guard let imageData = suggestedRestaurant.image else { return  }
        guard let image = UIImage(data: imageData) else { return  }
        
        do {
            try image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
            let restaurantImage = try UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil)
            content.attachments = [restaurantImage]
            
        }catch let err{
            completionHandler(err)
        }
        
        
        
        //        // Add custom action
        
        let categoryIdentifer = "foodpin.restaurantaction"
        let makeReservationAction = UNNotificationAction(identifier: "foodpin.makeReservation", title: "Reserve a table", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "foodpin.cancel", title: "Later", options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifer, actions: [makeReservationAction, cancelAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryIdentifer
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "rests", content: content, trigger: trigger)
        //
        //        //schedule notifications
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completionHandler)
    }
}
