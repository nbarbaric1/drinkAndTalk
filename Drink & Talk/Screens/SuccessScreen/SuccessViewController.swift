//
//  SuccessViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 24.09.2021..
//

import UIKit

class SuccessViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var newGameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

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

extension SuccessViewController {
    @IBAction func newGameButtonActionHandler() {
        navigateToLoginScreen()
    }
}
