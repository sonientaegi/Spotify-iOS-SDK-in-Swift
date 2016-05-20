//
//  ViewController.swift
//  SpotifyDemo
//
//  Created by SonienTaegi on 2016. 5. 18..
//
//  Contact    sonientaegi@gmail.com
//             sonien.net
//
//  Copyright © 2016년 Sonien Studio. All rights reserved.

import UIKit

class ViewController: UIViewController, SPTAuthViewDelegate {
    var player:SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let auth = SPTAuth.defaultInstance()
        auth.clientID        = "Put your own value"
        auth.redirectURL     = NSURL.init(string:"Put your own url")
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        let authvc = SPTAuthViewController.authenticationViewController()
        // authvc.clearCookies(nil)
        authvc.modalPresentationStyle   = UIModalPresentationStyle.OverCurrentContext
        authvc.modalTransitionStyle     = UIModalTransitionStyle.CrossDissolve
        authvc.delegate                 = self
        
        self.modalPresentationStyle     = UIModalPresentationStyle.CurrentContext
        self.definesPresentationContext = true
        self.presentViewController(authvc, animated: true, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        print("Login")
        initiatePlayer(session)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("Fail to login")
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("Cancel login")
    }
    
    func initiatePlayer(session: SPTSession!) -> Bool {
        if self.player == nil {
            self.player = SPTAudioStreamingController.init(clientId: SPTAuth.defaultInstance().clientID)
        }
        
        if let player = self.player {
            if !player.loggedIn {
                player.loginWithSession(session, callback: self.didLogin)
            }
            else {
                performSelector(#selector(self.didLogin), withObject: nil)
            }
            return true
        }
        else {
            return false
        }
    }
    
    @objc private func didLogin(error:NSError!) {
        // print(NSThread.isMainThread())
        
        if error != nil {
            let msg = "FAIL : " + error.debugDescription
            print(msg)
        }
        else if let player = self.player {
            let trackUri:NSURL! = NSURL.init(string: "spotify:track:58s6EuEYJdlb0kO7awm3Vp")
            player.playURIs([trackUri], fromIndex: 0, callback: self.didPlay)
            print("Playing request")
        }
        else {
            print("Player is not initiated")
        }
    }
    
    @objc private func didPlay(error:NSError!) {
        // print(NSThread.isMainThread())
        
        if error != nil {
            let msg = "FAIL : " + error.debugDescription
            print(msg)
        }
        else {
            print("Now playing")
        }
    }
}

