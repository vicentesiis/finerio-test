//
//  LoginViewController.swift
//  finerio-test
//
//  Created by Macintosh HD on 08/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginDidPressed(_ sender: Any) {
        
        if email.text != "" && password.text != "" {
            
            if isValidEmail(email: email.text ?? "") {
                login()
            } else {
                Utils.presentAlert(viewController: self, title: "Ups!", message: "Introduzca un correo valido")
            }
            
        } else {
            Utils.presentAlert(viewController: self, title: "Ups!", message: "Introduzca sus credenciales")
        }
        
    }
    
    private func login() {
        
        RestAPI.login(parameters: ["username": email.text!, "password": password.text!]) { (response) in
            
            switch response {
                
            case .success(let login):
                
                let defaults = UserDefaults.standard
                
                defaults.set(login.accessToken, forKey: "AccessToken")
                defaults.set(login.refreshToken, forKey: "RefreshToken")
                defaults.set(login.username, forKey: "Email")
                defaults.synchronize()
                
                RestAPI.currentUser { (response) in
                    
                    switch response {
                        
                    case .success(let user):
                        defaults.set(user.id, forKey: "UserID")
                        defaults.synchronize()
                        self.performSegue(withIdentifier: "home", sender: nil)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        Utils.presentAlert(viewController: self, title: "Ups!", message: "Ha ocurrido un error inesperado")
                    }
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                Utils.presentAlert(viewController: self, title: "Ups!", message: "Credenciales incorrectas")
                
            }
        }
        
    }
    
    // MARK: - Functions helper

    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

