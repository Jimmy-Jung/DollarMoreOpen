//
//  NotificationHandler.swift
//  DollarMoreRefactor
//
//  Created by 정준영 on 2023/06/11.
//

import Foundation
import UserNotifications

final class NotificationHandler{
      //Permission function
      public func askNotificationPermission(completion: @escaping ()->Void){
          //Permission to send notifications
          let center = UNUserNotificationCenter.current()
          // Request permission to display alerts and play sounds.
          center.requestAuthorization(options: [.alert, .badge, .sound])
          { (granted, error) in
              // Enable or disable features based on authorization.
              completion()
          }
      }
  }
