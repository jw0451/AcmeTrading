//
//  LoginViewController.swift
//  AcmeTrading
//
//  Created by John Wilson on 27/10/2020.
//

import UIKit

class LoginViewController: UIViewController {

    let logo = UIImageView()
    let errorView = UIView()
    let errorLabel = UILabel()
    let usernameLabel = UILabel()
    let usernameField = UITextField()
    let passwordLabel = UILabel()
    let passwordField = UITextField()
    let loginButton = GradientButton()
    let registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = UIColor.backgroundColor
        
        let stackView = BetterStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.margin = 20
        stackView.spacing = 10
        self.view.addSubview(stackView)
        stackView.autoPinEdge(toSuperviewEdge: .left)
        stackView.autoPinEdge(toSuperviewEdge: .right)
        stackView.autoCenterInSuperview()

        let logoImage = UIImage(named: "Logo")
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.autoSetDimensions(to: CGSize(width: 185, height: 75))
        
        let logoContainer = UIView()
        logoContainer.addSubview(logo)
        logo.autoCenterInSuperview()
        logoContainer.autoSetDimension(.height, toSize: 150)
        stackView.addArrangedSubview(logoContainer)
        stackView.setCustomSpacing(20, after: logoContainer)

        errorLabel.text = "error"
        errorLabel.textColor = .white
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorView.addSubview(errorLabel)
        errorLabel.autoCenterInSuperview()
        errorLabel.contentMode = .center
        errorView.autoSetDimension(.height, toSize: 44)
        errorView.backgroundColor = .red
        errorView.alpha = 0
        errorView.layer.cornerRadius = 4.0
        errorView.clipsToBounds = true
        stackView.addArrangedSubview(errorView)
        
        usernameLabel.text = "Username"
        stackView.addArrangedSubview(usernameLabel)

        usernameField.placeholder = "E.g. Gary123"
        let usernameContainer = UIView()
        usernameContainer.backgroundColor = .white
        usernameContainer.layer.cornerRadius = 4.0
        usernameContainer.clipsToBounds = true
        usernameContainer.addSubview(usernameField)
        usernameField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        stackView.addArrangedSubview(usernameContainer)

        passwordLabel.text = "Password"
        stackView.addArrangedSubview(passwordLabel)
        
        passwordField.isSecureTextEntry = true
        let passwordContainer = UIView()
        passwordContainer.backgroundColor = .white
        passwordContainer.layer.cornerRadius = 4.0
        passwordContainer.clipsToBounds = true
        passwordContainer.addSubview(passwordField)
        passwordField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        stackView.addArrangedSubview(passwordContainer)

        stackView.addArrangedSubview(UIView())
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.gradientColors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor]
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginButton.autoSetDimension(.height, toSize: 34)
        loginButton.layer.cornerRadius = 17.0
        loginButton.clipsToBounds = true
        stackView.addArrangedSubview(loginButton)
        
        let registerString = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        registerString.append(NSAttributedString(string: "Register", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]))
        registerButton.setAttributedTitle(registerString, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.sizeToFit()
        stackView.addArrangedSubview(registerButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for textField in  [usernameField, passwordField] {
            textField.text = ""
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
    }
    
    @objc func loginAction(_ sender: UIButton) {
        guard var username = usernameField.text, !username.isEmpty, var password = passwordField.text, !password.isEmpty else {
            showError()
            return
        }
        hideError()
        
        username = "user@morpheustest.com"
        password = "Password1"
        APIService().login(username: username, password: password) { (loginResponse, error) in
            if let error = error {
                print(error)
                self.showError()
            }
            if let loginResponse = loginResponse {
                print(loginResponse.data.userMessage)
                UserManager.shared.authToken = loginResponse.data.authToken
                UserManager.shared.refreshToken = loginResponse.data.refreshToken
                DispatchQueue.main.async {
                    self.showProfileView()
                }
            }
        }
    }
    
    func hideError() {
        UIView.animate(withDuration: 0.25) {
            self.errorView.alpha = 0
        }
    }
    
    func showError(_ error: String = "Please enter a valid username and password.") {
        errorLabel.text = error
        UIView.animate(withDuration: 0.25) {
            self.errorView.alpha = 1.0
        }
    }
    
    func showProfileView() {
        let profileVC = ProfileListViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func registerAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "I'm sorry", message:
            "This function wasn't defined", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
}
