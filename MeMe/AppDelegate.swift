//
//  AppDelegate.swift
//  MeMe
//
//  Created by Noel Maldonado on 5/4/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var memes = [MeMe]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadMemes()
        return true
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

    
    func loadMemes() {
        let memes = [
            
            MeMe(topText: "THERE WAS A SPIDER", bottomText: "IT'S GONE NOW", image: UIImage(named: "1"), meme: UIImage(named: "1")),
            MeMe(topText: "ONE DOES NOT SIMPLY", bottomText: "UNDERSTAND ALL MEMES", image: UIImage(named: "2"), meme: UIImage(named: "2")),
            MeMe(topText: "SHOUTOUT TO SIDEWALKS", bottomText: "FOR KEEPING ME OFF THE STREETS", image: UIImage(named: "3"), meme: UIImage(named: "3")),
            MeMe(topText: "WHEN YOU JUST BOOKED A TRIP", bottomText: "AND YOU CAN'T WAIT ANY LONGER", image: UIImage(named: "4"), meme: UIImage(named: "4")),
            MeMe(topText: "I DON'T THINK THAT MEMES", bottomText: "WHAT YOU THINK IT MEMES", image: UIImage(named: "5"), meme: UIImage(named: "5")),
            MeMe(topText: "TO MEME OR NOT TO MEME", bottomText: "THAT IS THE QUESTION", image: UIImage(named: "6"), meme: UIImage(named: "6")),
            MeMe(topText: "IF YOU DON'T STUDY", bottomText: "YOU SHALL NOT PASS", image: UIImage(named: "7"), meme: UIImage(named: "7")),
            MeMe(topText: "I HAVE NO IDEA", bottomText: "WHAT I'M DOING.", image: UIImage(named: "8"), meme: UIImage(named: "8"))
            
            
        ]
        
        for meme in memes {
            self.memes.append(meme)
            print(meme)
        }
        
    }
    
    

}

