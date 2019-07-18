//
//  AppDelegate.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/15/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
// We need to import MultipeerConnectivity
import MultipeerConnectivity
import RealmSwift

// Here "dc" acts as the service type identifier prefix and
// "cardshare" identifies the function of the service
// NOTE: A service type should be a short text string in the same format
// as a Bonjour service type that describes the app's networking protocol
// Up to 14 characters, lowercaes ASCII letters, numbers and hypens
let servicetype = "dc-cardshare"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var realm = try! Realm()
  var myCard: Card?
  
  var session: MCSession!
  var peerId: MCPeerID!
  var advertiserAssistant: MCAdvertiserAssistant!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if let uuid = UserDefaults.standard.string(forKey: "UUID") {
      myCard = realm.object(ofType: Card.self, forPrimaryKey: uuid)
    }
    /// Initialize and start the advertiser
    // 1 Initialize an MCPeerID object with peer display name.
    let peerName = myCard?.firstName ?? UIDevice.current.name
    peerId = MCPeerID(displayName: peerName)
    // 2 Initialize an instance of MCSession and set security
    session = MCSession(peer: peerId,
                        securityIdentity: nil,
                        encryptionPreference: .none)
    session.delegate = nil
    // 3 Initialize MCAdvertiserAssistant with the service type identifier
    // and MCSession instace we created. discoveryInfo is a dictionary of
    // pairs advertised to peer browsers.
    advertiserAssistant = MCAdvertiserAssistant(serviceType: servicetype,
                                                discoveryInfo: nil,
                                                session: session)
    // 4 Being advertising the service
    advertiserAssistant!.start()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

