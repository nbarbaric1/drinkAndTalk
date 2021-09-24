//
//  PlayingViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 24.09.2021..
//

import UIKit
import Firebase
import CoreMotion

class PlayingViewController: UIViewController {

    // MARK: - Properties
    var ref: DatabaseReference!
    var gameId: String?
    var myAlias: String?
    var duration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let duration = duration else { return }
        configureUI()
        configureFirebase()
        waitForLoser()
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            
            notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        Timer.scheduledTimer(withTimeInterval: Double(duration), repeats: false) { _ in
            self.navigateToSuccessScreen()
        }
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    @objc func appMovedToBackground() {
       print("app enters background")
       iAmLoser()
    }

    @objc func appCameToForeground() {
       print("app enters foreground")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        
        if view.frame.contains(location) {
            iAmLoser()
        }
    }
}

// MARK: - Functions
private extension PlayingViewController {
    
    func iAmLoser(){
        guard let gameId = gameId,
              let myAlias = myAlias
        else { return }
        
        ref.child("games").child(gameId).child("loser").setValue(["loserAlias" : myAlias]){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func configureUI(){
        guard let duration = duration else { return }
        UIApplication.shared.isIdleTimerDisabled = true
        UIView.animate(withDuration: 10, delay: 5, options: .allowUserInteraction){
            self.view.backgroundColor = .black
        }
    }
    
    func configureFirebase(){
        ref = Database.database().reference()
    }
    
    func waitForLoser(){
        guard let gameId = gameId else { return }
        
        ref.child("games").child(gameId).child("loser").observe(.childAdded, with: { snapshot in
            
            if let val = snapshot.value as? String,
               val != "-" {
                self.navigateToLoserScreen(for: val)
            }
        })
    }
    
    func navigateToLoserScreen(for loserAlias: String){
        let nextScreen = "Loser"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! LoserViewController
        nextViewController.loserAlias = loserAlias
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
    
    func navigateToSuccessScreen(){
        let nextScreen = "Success"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! SuccessViewController
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
}


      
