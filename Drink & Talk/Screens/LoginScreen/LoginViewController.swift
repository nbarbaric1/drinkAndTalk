//
//  ViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 21.09.2021..
//

import UIKit

class LoginViewController: UIViewController {
    
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
    }
}

