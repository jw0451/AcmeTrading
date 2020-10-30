//
//  LoginViewController.swift
//  AcmeTrading
//
//  Created by John Wilson on 27/10/2020.
//

import UIKit

class LoginViewController: UIViewController {

    let scrollView = UIScrollView()
    let stackView = BetterStackView()
    let logo = UIImageView()
    let errorView = UIView()
    let errorLabel = UILabel()
    let usernameLabel = UILabel()
    let usernameField = UITextField()
    let passwordLabel = UILabel()
    let passwordField = UITextField()
    let loginButton = GradientButton()
    let registerButton = UIButton()
        
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = UIColor.backgroundColor
        
        self.view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        
        let centerView = UIView()
        centerView.autoSetDimensions(to: UIScreen.main.bounds.size)
        scrollView.addSubview(centerView)
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.margin = 20
        stackView.spacing = 10
        centerView.addSubview(stackView)
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
        usernameLabel.textColor = .darkBlue
        stackView.addArrangedSubview(usernameLabel)

        usernameField.placeholder = "E.g. Gary123"
        usernameField.textColor = .black
        let usernameContainer = UIView()
        usernameContainer.backgroundColor = .white
        usernameContainer.layer.cornerRadius = 4.0
        usernameContainer.clipsToBounds = true
        usernameContainer.addSubview(usernameField)
        usernameField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        stackView.addArrangedSubview(usernameContainer)

        passwordLabel.text = "Password"
        passwordLabel.textColor = .darkBlue
        stackView.addArrangedSubview(passwordLabel)
        
        passwordField.isSecureTextEntry = true
        passwordField.textColor = .black
        let passwordContainer = UIView()
        passwordContainer.backgroundColor = .white
        passwordContainer.layer.cornerRadius = 4.0
        passwordContainer.clipsToBounds = true
        passwordContainer.addSubview(passwordField)
        passwordField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        stackView.addArrangedSubview(passwordContainer)

        stackView.addArrangedSubview(UIView())
        
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.gradientColors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor]
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginButton.autoSetDimension(.height, toSize: 50)
        loginButton.layer.cornerRadius = 25.0
        loginButton.clipsToBounds = true
        stackView.addArrangedSubview(loginButton)
        
        let registerString = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        registerString.append(NSAttributedString(string: "Register", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.darkBlue]))
        registerButton.setAttributedTitle(registerString, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.sizeToFit()
        stackView.addArrangedSubview(registerButton)
        
        let spacerView = UIView()
        bottomConstraint = spacerView.autoSetDimension(.height, toSize: 0)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if notification.name == UIResponder.keyboardWillHideNotification {
                self.scrollView.contentInset = .zero
                self.scrollView.contentOffset = .zero
            } else {
                let loginY = self.scrollView.bounds.size.height - self.loginButton.frame.origin.y
                let keyboardDeltaY = keyboardViewEndFrame.height - self.view.safeAreaInsets.bottom
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardDeltaY, right: 0)
                self.scrollView.contentOffset = CGPoint(x: 0, y: loginY - keyboardDeltaY + 20)
            }
        })
    }
}
