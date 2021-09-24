//
//  LouserViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 24.09.2021..
//

import UIKit

class LoserViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var loserLabel: UILabel!
    
    // MARK: - Properties
    var loserAlias: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let loserAlias = loserAlias else {
            return
        }
        configureUI()
    }
}

// MARK: - Functions
private extension LoserViewController {
    func configureUI() {
        newGameButton.makeRoundedTopCorners(withCornerRadius: 55)
        containerView.makeRounded(withCornerRadius: 55)
        loserLabel.text = loserAlias
    }
    
    func navigateToLoginScreen(){
        let nextScreen = "Login"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! LoginViewController
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
}

// MARK: - IBActions
extension LoserViewController {
    @IBAction func newGameButtonActionHandler() {
        navigateToLoginScreen()
    }
}
