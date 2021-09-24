//
//  GetReadyViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 24.09.2021..
//

import UIKit
import Firebase

class GetReadyViewController: UIViewController {
    
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Properties
    
    private var ref: DatabaseReference!
    var gameId: String?
    var myAlias: String?
    var secondsToWait = 10
    var duration: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebase()
        startTimer()
        getDuration()
    }
}
// MARK: - Functions
extension GetReadyViewController {
    func configureFirebase(){
        ref = Database.database().reference()
    }
    
    func startTimer(){
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.timerLabel.text = String(self.secondsToWait)
            self.secondsToWait = self.secondsToWait - 1
            
            if self.secondsToWait == -1 {
                timer.invalidate()
                self.navigateToPlayingScreen()
            }
        }
    }
    
    func navigateToPlayingScreen(){
        guard let gameId = gameId else { return }
        guard let myAlias = myAlias else { return }
        
        let nextScreen = "Playing"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! PlayingViewController
        nextViewController.gameId = gameId
        nextViewController.myAlias = myAlias
        nextViewController.duration = duration
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func configureUI(with duration: Int){
        
        let (h, m, _) = secondsToHoursMinutesSeconds(seconds: duration)
        
        var firstString = "Ukoliko podigneš mobitel\n"
        let secondString =  " u sljedećih \(h) H : \(m) MIN"
        let thirdString = "\no stalim sudionicima igre doći će \n notifikacija da si izgubio. \n\nBudi fer i plati piće ako gubiš."

        let f = firstString + secondString + thirdString
        
        descriptionLabel.text = f
    }
    
    func getDuration() {
        guard let gameId = gameId else { return }
        ref.child("games").child(gameId).child("states").observe(.childAdded, with: { snapshot in
            
            if let val = snapshot.value as? Int {
                self.configureUI(with: val)
                self.duration = val
            }
        })
    }
}

