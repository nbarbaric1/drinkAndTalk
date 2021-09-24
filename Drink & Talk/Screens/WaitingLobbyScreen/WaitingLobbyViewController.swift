//
//  WaitingLobbyViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 23.09.2021..
//

import UIKit
import Firebase

class WaitingLobbyViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var exitGameButton: UIButton!
    @IBOutlet private weak var playersTableView: UITableView!
    @IBOutlet private weak var gameDurationLabel: UILabel!
    @IBOutlet private weak var administratorNameLabel: UILabel!
    
    // MARK: Properties
    
    private var players: [Player] = []
    private var ref: DatabaseReference!
    var gameId: String?
    var myAlias: String?
    var isPlayerSaved: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebase()
        getPlayers()
        addPlayer()
        configureUI()
        waitForStart()
    }
}
// MARK: - IBActions
extension WaitingLobbyViewController {
    @IBAction func exitGameButtonActionHandler(){
        navigateToLoginScreen()
    }
}

// MARK: - Functions
private extension WaitingLobbyViewController {
    
    func waitForStart(){
        guard let gameId = gameId else { return }
        
        ref.child("games").child(gameId).child("waiting").observe(.childAdded, with: { snapshot in
            if let val = snapshot.value as? String,
               val == "YES" {
                self.navigateToGetReadyScreen()
            }
        })
    }
    
    func configureUI(){
        containerView.makeRounded(withCornerRadius: 30)
        exitGameButton.makeRounded(withCornerRadius: 30)
    }
    
    func configureFirebase(){
        ref = Database.database().reference()
    }
    
    func navigateToLoginScreen(){
        let nextScreen = "Login"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! LoginViewController
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
    
    func navigateToGetReadyScreen(){
        let nextScreen = "GetReady"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! GetReadyViewController
        nextViewController.myAlias = myAlias
        nextViewController.gameId = gameId
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
    
    func addPlayer(){
        guard let gameId = gameId,
              let myAlias = myAlias
        else { return }
        
        let playerRandomId: String? = ref.child("games").child(gameId).child("players").childByAutoId().key
        guard let playerRandomId = playerRandomId else { return }
        
        let playerId = "player" + playerRandomId
        
        ref.child("games").child(gameId).child("players").child(playerId).setValue(["alias" : myAlias]){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                self.isPlayerSaved = true
            }
        }
    }
    
    func getPlayers(){
        
        guard let gameId = gameId else { return }
        
        ref.child("games").child(gameId).child("players").observe(.childAdded, with: { snapshot in
            let player = Player(withSnap: snapshot)
            self.players.append(player)
            self.playersTableView.reloadData()
        })
                
        ref.child("games").child(gameId).child("administrator").child("alias").observe(.value) { snapshot in
            
            let name: String = snapshot.value as? String ?? "nepoznato"
            self.administratorNameLabel.text = name
        }
    }
}
// MARK: - TableView Delegate
extension WaitingLobbyViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}

extension WaitingLobbyViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayerTableViewCell.self), for: indexPath) as! PlayerTableViewCell
        let textToShow = String(indexPath.row + 1) + ". " + players[indexPath.row].alias
        cell.configureLabel(with: textToShow)
        return cell
    }
}
