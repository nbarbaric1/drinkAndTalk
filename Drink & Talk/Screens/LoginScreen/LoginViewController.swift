//
//  ViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 21.09.2021..
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var aliasInputTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension LoginViewController {
    
    func configureUI(){
        aliasInputTextField.makeRounded(withCornerRadius: 30)
        aliasInputTextField.setLeftPaddingPoints(30)
        loginButton.makeRounded(withCornerRadius: 75)
        let barutaFont = UIFont(name: "BarutaBlack", size: UIFont.buttonFontSize) ?? UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        loginButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: barutaFont)
        loginButton.titleLabel?.adjustsFontForContentSizeCategory = true
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - IBActions

extension LoginViewController {
    @IBAction func aliasInputEditingChangedActionHandler(){
        if let input = aliasInputTextField.text,
               input.count > 3 && input.count < 30 {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        }
        else{
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
    }
    
    @IBAction func loginButtonActionHandler(){
        
        let nextScreen = "CreateGame"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard
            .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! CreateGameViewController
        nextViewController.myAlias = aliasInputTextField.text?.uppercased()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

