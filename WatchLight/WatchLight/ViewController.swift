//
//  ViewController.swift
//  WatchLight
//
//  Created by Alliston Aleixo on 09/01/17.
//  Copyright © 2017 Alliston Aleixo. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate, UIScrollViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView:  UIScrollView!
    
    // MARK: - Properties
    var watchSession :  WCSession?
    var scrollWidth :   CGFloat?    = 120;
    var scrollHeight :  CGFloat     = UIScreen.main.bounds.size.height  - 163.0;
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad();
        
        /*
         * If this device can support a WatchConnectivity session,
         * obtain a session and activate.
         *
         * It isn't usually recommended to put this in viewDidLoad,
         * we're only doing it here to keep the app simple
         *
         * Note: Even though we won't be receiving messages in the View Controller,
         * we still need to supply a delegate to activate the session
         */
        if(WCSession.isSupported()){
            watchSession = WCSession.default()
            watchSession!.delegate = self
            watchSession!.activate()
        }
        
        let page = UserDefaults.standard.integer(forKey: "Page");
        setColor(page);
        
        // Scroll View
        scrollView?.contentSize = CGSize(width: (scrollWidth! * 3), height: scrollHeight)
        scrollView?.delegate    = self;
        
        for i in 0...2 {
            let imgView = UIImageView.init()
            imgView.frame = CGRect(x: scrollWidth! * CGFloat (i), y: 0, width: scrollWidth!, height: scrollHeight)
            
            if i == 0 {
                imgView.backgroundColor = UIColor.white;
            }
            
            if i == 1 {
                imgView.backgroundColor = UIColor.blue;
            }
            
            
            if i == 2 {
                imgView.backgroundColor = UIColor.yellow;
            }
            
            scrollView?.addSubview(imgView);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect( x: scrollWidth! * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth!, height: scrollHeight), animated: true)
    }
    
    // MARK: - WatchConnectivity
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("Session Activated at iPhone");
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        debugPrint("Session Inactivated at iPhone");
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        debugPrint("Session Deactivated at iPhone");
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width;
        let page: Int = Int(ceil(((scrollView.contentOffset.x + width) / width) - 1));
        
        setColor(page);
    }
    
    // MARK: - Private Methods
    func setColor(_ page: Int) {
        var resultColor: String?;
        
        switch page {
        case 1:
            resultColor = "Blue";
        case 2:
            resultColor = "Yellow";
        default:
            resultColor = "White";
        }
        
        pageControl.currentPage = Int(page);
        
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width;
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true);
        
        UserDefaults.standard.set(page, forKey: "Page");
        
        let resultData: [String: String] = [
            "ResultColor" : resultColor!
        ];
        
        do {
            try watchSession?.updateApplicationContext(resultData);
            
            let generator = UIImpactFeedbackGenerator(style: .light);
            generator.impactOccurred()
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }
}

