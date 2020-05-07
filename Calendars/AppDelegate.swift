//
//  AppDelegate.swift
//  Calendars
//
//  Created by Rafin Rahman on 21/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import NotificationCenter

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let centre = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.sound, .alert]
        
        centre.requestAuthorization(options: options){(granted, error) in
            if error != nil {
                print(error)
            }
        }
        centre.delegate=self
        
        return true
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Calendars")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension String{
    func toDate(dateFormat:String) -> Date! {
        let dateAndTimeFormat = DateFormatter()
        dateAndTimeFormat.dateFormat = dateFormat
        return dateAndTimeFormat.date(from: self)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIResponder {
    
    func getOwningViewController() -> UIViewController? {
        var nextResponser = self
        while let next = nextResponser.next {
            nextResponser = next
            if let viewController = nextResponser as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


public enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

public enum Month: Int {
    case january = 1, february, march, april, may, june, july, august, september, october, november, december
}

extension Date {
    func toString(dateFormat:String) -> String! {
        let dateAndTimeFormat = DateFormatter()
        dateAndTimeFormat.dateFormat = dateFormat
        return dateAndTimeFormat.string(from: self)
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func stripDate() -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    public func nextWeekDay(_ weekday: Weekday,
                     direction: Calendar.SearchDirection = .forward,
                     considerToday: Bool = false) -> Date
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)
        
        if considerToday &&
            calendar.component(.weekday, from: self) == weekday.rawValue
        {
            return self
        }
        
        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: direction)!
    }
    
    public func nextMonth(_ month: Month,
                     direction: Calendar.SearchDirection = .forward,
                     considerToday: Bool = false) -> Date
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(month: month.rawValue)
        
        if considerToday &&
            calendar.component(.month, from: self) == month.rawValue
        {
            return self
        }
        
        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: direction)!
    }
    
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d",hours,minutes)
        
    }
}

//enum ScrollDirection {
//    case Top
//    case Bottom
//
//    func contentOffsetWith(scrollView: UIScrollView, event:Events) -> CGPoint {
//        var contentOffset = CGPoint.zero
//        switch self {
//            case .Top:
//                contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
//
//            case .Bottom:
//                contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y + 100 ) //scrollView.contentSize.height - scrollView.bounds.size.height
//        }
//        return contentOffset
//    }
//}
//
//extension UIScrollView {
//    func scrollTo(event: Events, view: DetailView) {
//
//
//        let startHour = CGFloat(Calendar.current.component(.hour, from: event.startDate))
//        let endHour = CGFloat(Calendar.current.component(.hour, from: event.endDate))
//
//        let startMinute = (CGFloat(Calendar.current.component(.minute, from: event.startDate)))/60
//        let endMinute = (CGFloat(Calendar.current.component(.minute, from: event.endDate)))/60
//
//        let finalStartTime = (startHour+startMinute) * 62
//        let finalEndTime = (endHour+endMinute) * 62
//
//        let newPoint: CGPoint
//        if finalStartTime > view.frame.height  {
//            let newY = finalStartTime - view.frame.height
//            newPoint = CGPoint(x: 0, y: newY)
//        } else {
//            var newY = finalStartTime
//            if newY + self.frame.height > contentSize.height {
//                newY = contentSize.height - self.frame.height
//            }
//            newPoint = CGPoint(x: 0, y: newY)
//        }
//        self.setContentOffset(newPoint, animated: false)
//    }
//}
