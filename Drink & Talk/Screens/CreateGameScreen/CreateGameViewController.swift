//
//  CreateGameViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 22.09.2021..
//

import UIKit

class CreateGameViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var myAliasLabel: UILabel!
    @IBOutlet private weak var loginExistingGame: UIButton!
    
    // MARK: Properties
    var myAlias: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myAlias = myAlias else {
            return
        }
        configureUI()
    }
}

private extension CreateGameViewController {
    func configureUI(){
        myAliasLabel.text = myAlias
        loginExistingGame.makeRounded(withCornerRadius: 55)
    }
}

extension CreateGameViewController {
    @IBAction func createGame(){
        let nextScreen = "NewGame"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard
            .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! NewGameViewController
        nextViewController.myAlias = myAlias
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
