//
//  LoginViewController.swift
//  USTTest
//
//  Created by Manickam on 17/10/24.
//

import UIKit
import GoogleSignIn
class LoginViewController: UIViewController {

    
    @IBOutlet weak var GsignInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         if OAuthLoginManager.shared().isUserLoggedIn() {
            OAuthLoginManager.shared().silentLogin { success in
                        if success {
                            self.navigateToHome()
                        } else {
                            self.showLoginButton()
                        }
                    }
         }else{
             print("Showing Login screen")
             self.showLoginButton()
         }

        // Do any additional setup after loading the view.
    }
    func showLoginButton() {
        DispatchQueue.main.async { [self] in
            GsignInButton.isHidden = false;
        }
        }
    func hideLoginButton() {
        DispatchQueue.main.async { [self] in
            GsignInButton.isHidden = true;
        }
        }
    func navigateToHome(){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerID") as! HomeViewController
            if let navigationController = self.navigationController {
                navigationController.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }

        }
    }
    
    @IBAction func googleSignInTapped(_ sender: UIButton) {
            OAuthLoginManager.shared().login { success, token in
                if success {
                    print("Logged in with token: \(token ?? "")")
                    self.navigateToHome()
                } else {
//                    self.showLoginError()
                }
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
