//
//  InterfaceController.swift
//  WatchLight WatchKit Extension
//
//  Created by Alliston Aleixo on 09/01/17.
//  Copyright © 2017 Alliston Aleixo. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var groupView: WKInterfaceGroup!
    
    // Our WatchConnectivity Session for communicating with the iOS app
    var watchSession : WCSession?
    
    override func awake(withContext context: Any?) {
        groupView.setBackgroundColor(UIColor.white);
        
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate();
        
        if(WCSession.isSupported()){
            watchSession = WCSession.default()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activate()
        }
        
        let colorObject = UserDefaults.standard.object(forKey: "Color");
        let stringColor = colorObject != nil ? colorObject as! String : "";
        
        debugPrint(stringColor);
        
        setColor(stringColor);
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("Session Activated at Watch");
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let stringColor = applicationContext["ResultColor"]! as! String;
        
        setColor(stringColor);
    }
    
    // MARK: - Private Methods
    func setColor(_ stringColor: String) {
        var color = UIColor.white;
        
        switch stringColor {
            case "White":
                color = UIColor.white;
            case "Blue":
                color = UIColor.blue;
            case "Yellow":
                color = UIColor.yellow;
            default:
                color = UIColor.white;
        }
        
        groupView.setBackgroundColor(color);
        UserDefaults.standard.set(stringColor, forKey: "Color");
        
        WKInterfaceDevice().play(.click)
    }
}
