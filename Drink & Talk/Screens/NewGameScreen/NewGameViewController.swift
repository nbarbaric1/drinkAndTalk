//
//  NewGameViewController.swift
//  Drink & Talk
//
//  Created by Nikola Barbarić on 22.09.2021..
//

import UIKit

class NewGameViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var qrContainerView: UIView!
    
    // MARK: Properties
    var myAlias: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // Do any additional setup after loading the view.
        qrImageView.image = generateQRCode(from: "OVO AKO RADI IZ PRVE EXO TI STA OS")
    }
}

extension NewGameViewController {
    
    @IBAction func btnHandler(){
        
        let nextScreen = "ScanQr"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard
            .instantiateViewController(withIdentifier: String(nextScreen + "ViewController")) as! ScanQrViewController
        navigationController?.pushViewController(nextViewController, animated: true)
   
    }
}

private extension NewGameViewController {
    
    func configureUI(){
        qrContainerView.makeRounded(withCornerRadius: 24)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
