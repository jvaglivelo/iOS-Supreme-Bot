//
//  ViewController.swift
//  iOS-Supreme-Bot
//
//  Created by Jordan Vaglivelo on 2/28/20.
//  Copyright © 2020 Jordan Vaglivelo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    //Variables
    var supremeBrowser: WKWebView?
    var supremeBot: Supreme?
    let defaults = UserDefaults.standard
    var botRunning:Bool = false
    
    //Objects
    @IBOutlet weak var webContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize Bot
        self.supremeBot = Supreme(withViewController: self)

        //Setup browser
        createSupremeBrowser()
        
    }

    //Setup the webview
    func createSupremeBrowser()
    {
        //Create webview and add to the container view
        supremeBrowser = WKWebView()
        webContainer.addSubview(supremeBrowser!)
        
        //Setup the frame so it displays correctly
        let frame = CGRect(x: 0, y: 0, width: webContainer.bounds.width, height: webContainer.bounds.height)
        supremeBrowser!.frame = frame
        
        //Load the URL
        self.supremeBrowser!.load(URLRequest(url: URL(string: "https://www.supremenewyork.com/mobile/#categories")!))
    }

        
    @IBAction func btnRunTapped(_ sender: Any) {
        if (botRunning == false){
            supremeBot?.startProcess()
        }
    }
    


}

