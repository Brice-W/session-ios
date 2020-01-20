
final class RestoreVC : UIViewController {
    private var spacer1HeightConstraint: NSLayoutConstraint!
    private var spacer2HeightConstraint: NSLayoutConstraint!
    private var spacer3HeightConstraint: NSLayoutConstraint!
    private var restoreButtonBottomOffsetConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Components
    private lazy var mnemonicTextField: TextField = {
        let result = TextField(placeholder: NSLocalizedString("Enter your recovery phrase", comment: ""))
        result.layer.borderColor = Colors.text.cgColor
        return result
    }()
    
    private lazy var legalLabel: UILabel = {
        let result = UILabel()
        result.textColor = Colors.text
        result.font = .systemFont(ofSize: Values.verySmallFontSize)
        let text = "By using this service, you agree to our Terms and Conditions and Privacy Statement"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: Values.verySmallFontSize), range: (text as NSString).range(of: "Terms and Conditions"))
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: Values.verySmallFontSize), range: (text as NSString).range(of: "Privacy Statement"))
        result.attributedText = attributedText
        result.numberOfLines = 0
        result.textAlignment = .center
        result.lineBreakMode = .byWordWrapping
        return result
    }()
    
    // MARK: Settings
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        // Set gradient background
        view.backgroundColor = .clear
        let gradient = Gradients.defaultLokiBackground
        view.setGradient(gradient)
        // Set up navigation bar
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Colors.navigationBarBackground
        // Set up logo image view
        let logoImageView = UIImageView()
        logoImageView.image = #imageLiteral(resourceName: "Session")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.set(.width, to: 32)
        logoImageView.set(.height, to: 32)
        navigationItem.titleView = logoImageView
        // Set up title label
        let titleLabel = UILabel()
        titleLabel.textColor = Colors.text
        titleLabel.font = .boldSystemFont(ofSize: isSmallScreen ? Values.largeFontSize : Values.veryLargeFontSize)
        titleLabel.text = NSLocalizedString("Restore your account", comment: "")
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        // Set up explanation label
        let explanationLabel = UILabel()
        explanationLabel.textColor = Colors.text
        explanationLabel.font = .systemFont(ofSize: Values.smallFontSize)
        explanationLabel.text = "Enter the recovery phrase that was given to you when you signed up to restore your account."
        explanationLabel.numberOfLines = 0
        explanationLabel.lineBreakMode = .byWordWrapping
        // Set up legal label
        legalLabel.isUserInteractionEnabled = true
        let legalLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLegalLabelTapped))
        legalLabel.addGestureRecognizer(legalLabelTapGestureRecognizer)
        // Set up spacers
        let topSpacer = UIView.vStretchingSpacer()
        let spacer1 = UIView()
        spacer1HeightConstraint = spacer1.set(.height, to: isSmallScreen ? Values.smallSpacing : Values.veryLargeSpacing)
        let spacer2 = UIView()
        spacer2HeightConstraint = spacer2.set(.height, to: isSmallScreen ? Values.smallSpacing : Values.veryLargeSpacing)
        let spacer3 = UIView()
        spacer3HeightConstraint = spacer3.set(.height, to: isSmallScreen ? Values.smallSpacing : Values.veryLargeSpacing)
        let bottomSpacer = UIView.vStretchingSpacer()
        let restoreButtonBottomOffsetSpacer = UIView()
        restoreButtonBottomOffsetConstraint = restoreButtonBottomOffsetSpacer.set(.height, to: Values.onboardingButtonBottomOffset)
        // Set up restore button
        let restoreButton = Button(style: .prominentFilled, size: .large)
        restoreButton.setTitle(NSLocalizedString("Continue", comment: ""), for: UIControl.State.normal)
        restoreButton.titleLabel!.font = .boldSystemFont(ofSize: Values.mediumFontSize)
        restoreButton.addTarget(self, action: #selector(restore), for: UIControl.Event.touchUpInside)
        // Set up restore button container
        let restoreButtonContainer = UIView()
        restoreButtonContainer.addSubview(restoreButton)
        restoreButton.pin(.leading, to: .leading, of: restoreButtonContainer, withInset: Values.massiveSpacing)
        restoreButton.pin(.top, to: .top, of: restoreButtonContainer)
        restoreButtonContainer.pin(.trailing, to: .trailing, of: restoreButton, withInset: Values.massiveSpacing)
        restoreButtonContainer.pin(.bottom, to: .bottom, of: restoreButton)
        // Set up top stack view
        let topStackView = UIStackView(arrangedSubviews: [ titleLabel, spacer1, explanationLabel, spacer2, mnemonicTextField, spacer3, legalLabel ])
        topStackView.axis = .vertical
        topStackView.alignment = .fill
        // Set up top stack view container
        let topStackViewContainer = UIView()
        topStackViewContainer.addSubview(topStackView)
        topStackView.pin(.leading, to: .leading, of: topStackViewContainer, withInset: Values.veryLargeSpacing)
        topStackView.pin(.top, to: .top, of: topStackViewContainer)
        topStackViewContainer.pin(.trailing, to: .trailing, of: topStackView, withInset: Values.veryLargeSpacing)
        topStackViewContainer.pin(.bottom, to: .bottom, of: topStackView)
        // Set up main stack view
        let mainStackView = UIStackView(arrangedSubviews: [ topSpacer, topStackViewContainer, bottomSpacer, restoreButtonContainer, restoreButtonBottomOffsetSpacer ])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        view.addSubview(mainStackView)
        mainStackView.pin(.leading, to: .leading, of: view)
        mainStackView.pin(.top, to: .top, of: view)
        mainStackView.pin(.trailing, to: .trailing, of: view)
        bottomConstraint = mainStackView.pin(.bottom, to: .bottom, of: view)
        topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor, multiplier: 1).isActive = true
        // Dismiss keyboard on tap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        // Listen to keyboard notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: General
    @objc private func dismissKeyboard() {
        mnemonicTextField.resignFirstResponder()
    }
    
    // MARK: Updating
    @objc private func handleKeyboardWillChangeFrameNotification(_ notification: Notification) {
        guard let newHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        bottomConstraint.constant = -newHeight // Negative due to how the constraint is set up
        restoreButtonBottomOffsetConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.largeSpacing
        spacer1HeightConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.mediumSpacing
        spacer2HeightConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.mediumSpacing
        spacer3HeightConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.mediumSpacing
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
        bottomConstraint.constant = 0
        restoreButtonBottomOffsetConstraint.constant = Values.onboardingButtonBottomOffset
        spacer1HeightConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.veryLargeSpacing
        spacer2HeightConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.veryLargeSpacing
        spacer3HeightConstraint.constant = isSmallScreen ? Values.smallSpacing : Values.veryLargeSpacing
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Interaction
    @objc private func restore() {
        func showError(title: String, message: String = "") {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            presentAlert(alert)
        }
        let mnemonic = mnemonicTextField.text!
        do {
            let hexEncodedSeed = try Mnemonic.decode(mnemonic: mnemonic)
            let seed = Data(hex: hexEncodedSeed)
            let keyPair = Curve25519.generateKeyPair(fromSeed: seed + seed)
            let identityManager = OWSIdentityManager.shared()
            let databaseConnection = identityManager.value(forKey: "dbConnection") as! YapDatabaseConnection
            databaseConnection.setObject(seed.toHexString(), forKey: "LKLokiSeed", inCollection: OWSPrimaryStorageIdentityKeyStoreCollection)
            databaseConnection.setObject(keyPair, forKey: OWSPrimaryStorageIdentityKeyStoreIdentityKey, inCollection: OWSPrimaryStorageIdentityKeyStoreCollection)
            TSAccountManager.sharedInstance().phoneNumberAwaitingVerification = keyPair.hexEncodedPublicKey
            mnemonicTextField.resignFirstResponder()
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                let displayNameVC = DisplayNameVC()
                self.navigationController!.pushViewController(displayNameVC, animated: true)
            }
        } catch let error {
            let error = error as? Mnemonic.DecodingError ?? Mnemonic.DecodingError.generic
            showError(title: error.errorDescription!)
        }
    }
    
    @objc private func handleLegalLabelTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let url = URL(string: "https://github.com/loki-project/loki-messenger-ios/blob/master/privacy-policy.md")!
        UIApplication.shared.open(url)
    }
}