//
//  CreateGameViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 22.09.2021..
//

import UIKit
import Firebase

class CreateGameViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var myAliasLabel: UILabel!
    @IBOutlet private weak var loginExistingGame: UIButton!
    @IBOutlet private weak var createGameButton: UIButton!
    
    // MARK: Properties
    var myAlias: String?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureFirebase()
    }
}

private extension CreateGameViewController {
    func configureUI(){
        myAliasLabel.text = myAlias
        loginExistingGame.makeRoundedTopCorners(withCornerRadius: 50)
        createGameButton.makeRounded(withCornerRadius: 100)
    }
    
    func configureFirebase(){
        ref = Database.database().reference()
    }
    
    func goBack() {
        let nextScreen = "Login"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard
            .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! LoginViewController
        navigationController?.setViewControllers([nextViewController], animated: true)
  
    }
}

extension CreateGameViewController {
    
    @IBAction func backButtonActionHandler() {
        goBack()
    }
    
    @IBAction func loginExistingGameButtonActionHandler(){
        guard let myAlias = myAlias else { return }
        let nextScreen = "ScanQr"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard
            .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! ScanQrViewController
        nextViewController.myAlias = myAlias
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func createGame(){
        
        let gameRandomId: String? = ref.child("games").childByAutoId().key
        guard let gameRandomId = gameRandomId else { return }
        let playerRandomId: String? = ref.child("games").child(gameRandomId).child("players").childByAutoId().key
        guard let playerRandomId = playerRandomId else { return }
        let gameId = "game" + gameRandomId
        let playerId = "player" + playerRandomId


        ref.child("games").child(gameId).child("players").child(playerId).setValue(["alias" : myAlias]){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                
            }
        }
        
        ref.child("games").child(gameId).child("administrator").setValue(["id" : playerId, "alias" : myAlias]){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                let nextScreen = "NewGame"
                let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
                let nextViewController = storyboard
                    .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! NewGameViewController
                nextViewController.gameId = gameId
                nextViewController.playerId = playerId
                nextViewController.myAlias = self.myAlias
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        
    }
}
