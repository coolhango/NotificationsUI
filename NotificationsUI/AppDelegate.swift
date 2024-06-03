// Last Updated: 2 June 2024, 3:42PM.
// Copyright © 2024 Gedeon Koh All rights reserved.
// No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in reviews and certain other non-commercial uses permitted by copyright law.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// Use of this program for pranks or any malicious activities is strictly prohibited. Any unauthorized use or dissemination of the results produced by this program is unethical and may result in legal consequences.
// This code have been tested throughly. Please inform the operator or author if there is any mistake or error in the code.
// Any damage, disciplinary actions or death from this material is not the publisher's or owner's fault.
// Run and use this program this AT YOUR OWN RISK.
// Version 0.1

// This Space is for you to experiment your codes
// Start Typing Below :) ↓↓↓

import UIKit
import UserNotifications

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    /// Request local notification authorizations.
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { accepted, error in
      if !accepted {
        print("Notification access denied.")
      }
    }
    
    /// Render actions for notification.
    let action = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
    let category = UNNotificationCategory(identifier: "normal", actions: [action], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
    
    return true
  }
  
  /// Create a local notification at specific date.
  ///
  /// - Parameter date: Time to trigger notification.
  func scheduleNotification(at date: Date) {
    UNUserNotificationCenter.current().delegate = self
    
    /// Create date component from date.
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents(in: .current, from: date)
    let newComponents = DateComponents.init(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
    
    /// Create trigger and content.
    let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
    let content = UNMutableNotificationContent()
    content.title = "Coding Reminder"
    content.body = "Ready to code? Let us do some Swift!"
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "normal"
    
    /// Add a image as attachment.
    if let path = Bundle.main.path(forResource: "Swift", ofType: "png") {
      let url = URL(fileURLWithPath: path)
      
      do {
        let attachment = try UNNotificationAttachment(identifier: "Swift", url: url, options: nil)
        content.attachments = [attachment]
      } catch {
        print("The attachment was not loaded.")
      }
    }
    
    /// Make a notification request.
    let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
    
    /// Remove pending notifications to avoid duplicates.
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
    /// Provide request to notification center.
    UNUserNotificationCenter.current().add(request) { (error) in
      if let error = error {
        print("Error: " + error.localizedDescription)
      }
    }
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if response.actionIdentifier == "remindLater" {
      let newDate = Date(timeInterval: 60, since: Date())
      scheduleNotification(at: newDate)
    }
  }
}
