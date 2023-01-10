//
//  ViewController.swift
//  Ashland QuaranTeam
//
//  Created by Elijah Retzlaff on 4/16/20.
//  Copyright © 2020 Ashland QuaranTeam. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //set up video in background
        setUpVideo()
        
    }
    
    func setUpVideo() {
        
        //get reasources in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginannimation", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        //create a url from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        //create video player item
        let item = AVPlayerItem(url: url)
        
        //create the palyer
        videoPlayer = AVPlayer(playerItem: item)
        
        //create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //adjust size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 1)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.85)
        
    }
    
    
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }


}

