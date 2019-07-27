//
//  AppDelegate.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/15/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
// Step 1. Advertising a service
// 1.1 Import MultipeerConnectivity framework
import MultipeerConnectivity
import RealmSwift

// 1.2 Declare a constant for the service type that's being advertised and
// searched for.
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
  
  // 1.3 Add session, peer and advertiser properties
  var session: MCSession!
  var peerId: MCPeerID!
  var advertiserAssistant: MCAdvertiserAssistant!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if let uuid = UserDefaults.standard.string(forKey: "UUID") {
      myCard = realm.object(ofType: Card.self, forPrimaryKey: uuid)
    }
    
    // Initialize and start the advertiser
    // 1.4 Initialize an MCPeerID object with peer display name.
    let peerName = myCard?.firstName ?? UIDevice.current.name
    peerId = MCPeerID(displayName: peerName)
    // 1.5 Initialize an instance of MCSession and set security
    session = MCSession(peer: peerId,
                        securityIdentity: nil,
                        encryptionPreference: .none)
    // 3.4 Set MCSession's delegate
    session.delegate = self
    // 1.6 Initialize MCAdvertiserAssistant with the service type identifier
    advertiserAssistant = MCAdvertiserAssistant(serviceType: servicetype,
                                                discoveryInfo: nil,
                                                session: session)
    // and MCSession instace we created. discoveryInfo is a dictionary of
    // 1.7 Being advertising the service
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

  // Step 4. Sending card to the peer
  // Now delegate emthods are in place, now we need to implement the logic
  // that actually sends the data to the peer
  // 4.1 Declare sendCardToPeer() function.
  // Convert `myCard` to data, so we can send it over, via session.send(_:toPeers:with)
  func sendCardToPeer() {
    if let data = try? JSONEncoder().encode(myCard) {
      try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
  }
}

// 3.2 Conform to MCSessionDelegate. Implement session(_:didReceive:fromPeer)
// Convert data to Card and save it to Realm. Post an event in .CalliDataReceivedNotification
// Then set self.sessions' delegate
extension AppDelegate: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    // Do nothing
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    // 3.3 Save Callicard. When writing to Realm, make sure that you are in
    // the same thread where Realm has been instiated. In this case, main thread
    if let card = try? JSONDecoder().decode(Card.self, from: data) {
      DispatchQueue.main.async {
        try? self.realm.write {
          self.realm.add(card, update: Realm.UpdatePolicy.modified)
          NotificationCenter.default.post(name: .CalliDataReceivedNotification, object: nil)
        }
      }
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    // Do nothing
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    // Do nothing
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    // Do nothing
  }
}
