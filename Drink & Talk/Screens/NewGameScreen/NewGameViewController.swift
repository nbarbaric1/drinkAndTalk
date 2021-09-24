//
//  NewGameViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 22.09.2021..
//

import UIKit
import Firebase
import FirebaseDatabase

class NewGameViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var qrContainerView: UIView!
    @IBOutlet private weak var durationPickerView: UIPickerView!
    @IBOutlet private weak var squadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var squadView: UIView!
    @IBOutlet private weak var startGameButton: UIButton!
    @IBOutlet private weak var expandListButton: UIButton!
    @IBOutlet private weak var shrinkListButton: UIButton!
    @IBOutlet private weak var playersTableView: UITableView!
    @IBOutlet private weak var loggedSquadLabelConstraint: NSLayoutConstraint!
    
    
    // MARK: Properties
    var gameId: String?
    var playerId: String?
    let durations: [String] = ["00H 30MIN", "01H 00MIN", "01H 30MIN", "02H 00MIN", "02H 30MIN", "03H 00MIN", "03H 30MIN", "04H 00MIN"]
    var ref: DatabaseReference!
    var players: [Player] = []
    var isListExpanded: Bool = false
    var myAlias: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebase()
        getPlayers()
        configureUI()
        configureQR()
        waitForStart()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.view),
            isListExpanded
        else { return }
        
        if !squadView.frame.contains(location) {
            shrinkList()
        }
    }
}

extension NewGameViewController {
    
    @IBAction func startGameButtonActionHandler(){
        startGame()
    }
    
    @IBAction func expandListButtonActionHandler(){
        expandList()
    }
    
    @IBAction func shrinkListButtonActionHandler(){
        shrinkList()
    }
    
    @IBAction func backButtonActionHandler() {
        goBack()
    }
}

private extension NewGameViewController {
    
    func goBack() {
        let nextScreen = "Login"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard
            .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! LoginViewController
        navigationController?.setViewControllers([nextViewController], animated: false)
    }
    
    func waitForStart(){
        guard let gameId = gameId else { return }
        
        ref.child("games").child(gameId).child("waiting").observe(.childAdded, with: { snapshot in
            if let val = snapshot.value as? String,
               val == "YES" {
                self.navigateToGetReadyScreen()
            }
        })
    }
    
    func startGame(){
        guard let gameId = gameId else { return }
        let pickerViewSelection = durationPickerView.selectedRow(inComponent: 0) + 1
        let minutes: Int = pickerViewSelection * 30
        let durationInSeconds: Int = minutes * 60
        
        ref.child("games").child(gameId).child("states").setValue(["duration" : durationInSeconds]){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
        
        ref.child("games").child(gameId).child("waiting").setValue(["isStarted" : "YES"]){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func navigateToGetReadyScreen(){
        let nextScreen = "GetReady"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! GetReadyViewController
        nextViewController.myAlias = myAlias
        nextViewController.gameId = gameId
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
    
    func expandList(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.squadViewHeightConstraint.constant = self.view.frame.height - 100
            self.loggedSquadLabelConstraint.constant = 24
            self.expandListButton.isHidden = true
            self.shrinkListButton.isHidden = false
            self.playersTableView.isScrollEnabled = true
            self.view.layoutIfNeeded()
        } completion: { status in
            print("status je \(status)")
            self.isListExpanded = true
        }
    }
    
    func shrinkList(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.squadViewHeightConstraint.constant = self.squadViewHeight()
            self.loggedSquadLabelConstraint.constant = -24
            self.expandListButton.isHidden = false
            self.shrinkListButton.isHidden = true
            self.playersTableView.isScrollEnabled = false
            self.view.layoutIfNeeded()
        } completion: { status in
            print("status je \(status)")
            self.isListExpanded = false
        }
    }
    
    func configureQR(){
        guard let gameId = gameId else { return }
        qrImageView.image = generateQRCode(from: gameId) ?? UIImage(named: "logo")
    }
    
    func configureUI(){
        qrContainerView.makeRounded(withCornerRadius: 24)
        durationPickerView.makeRounded(withCornerRadius: 30)
        squadView.makeRoundedTopCorners(withCornerRadius: 55)
        startGameButton.makeRoundedTopCorners(withCornerRadius: 55)
        configureSwipeGestures()
    }
    
    func configureSwipeGestures(){
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUpGesture(sender:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDownGesture(sender:)))
        swipeUpGesture.direction = .up
        swipeUpGesture.numberOfTouchesRequired = 1
        swipeDownGesture.direction = .down
        swipeDownGesture.numberOfTouchesRequired = 1
        squadView.addGestureRecognizer(swipeUpGesture)
        squadView.addGestureRecognizer(swipeDownGesture)
        swipeUpGesture.delegate = self
        swipeDownGesture.delegate = self
    }
    
    @objc func handleUpGesture(sender: UITapGestureRecognizer) {
        expandList()
    }
    
    @objc func handleDownGesture(sender: UITapGestureRecognizer) {
        shrinkList()
    }
    
    func configureFirebase(){
        ref = Database.database().reference()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func squadViewHeight() -> CGFloat {
        switch players.count {
        case 0, 1:
            return 260
        case 2:
            return 300
        case 3:
            return 320
        default:
            return 320
        }
    }
    
    func getPlayers(){
        
        guard let gameId = gameId else { return }
        
        ref.child("games").child(gameId).child("players").observe(.childAdded, with: { snapshot in
            self.players.append(Player(withSnap: snapshot))
            self.playersTableView.reloadData()
            if !self.isListExpanded {
                self.shrinkList()
            }
            
        })
    }
}

extension NewGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

extension NewGameViewController: UITableViewDataSource {
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

extension NewGameViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        durations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let barutaFont = UIFont(name: "BarutaBlack", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        return NSAttributedString(string: durations[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: barutaFont])
    }
}

extension NewGameViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
