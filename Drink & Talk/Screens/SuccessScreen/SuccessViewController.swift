//
//  SuccessViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 24.09.2021..
//

import UIKit

class SuccessViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var newGameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - Functions
private extension SuccessViewController {
    func configureUI() {
        containerView.makeRounded(withCornerRadius: 55)
        newGameButton.makeRounded(withCornerRadius: 55)
    }
    
    func navigateToLoginScreen(){
        let nextScreen = "Login"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! LoginViewController
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
}

// MARK: - IBActions
extension SuccessViewController {
    @IBAction func newGameButtonActionHandler() {
        navigateToLoginScreen()
    }
}
