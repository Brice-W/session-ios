
final class ExpandingAttachmentsButton : UIView, InputViewButtonDelegate {
    private weak var delegate: ExpandingAttachmentsButtonDelegate?
    private var isExpanded = false { didSet { expandOrCollapse() } }
    
    // MARK: Constraints
    private lazy var gifButtonContainerBottomConstraint = gifButtonContainer.pin(.bottom, to: .bottom, of: self)
    private lazy var documentButtonContainerBottomConstraint = documentButtonContainer.pin(.bottom, to: .bottom, of: self)
    private lazy var libraryButtonContainerBottomConstraint = libraryButtonContainer.pin(.bottom, to: .bottom, of: self)
    private lazy var cameraButtonContainerBottomConstraint = cameraButtonContainer.pin(.bottom, to: .bottom, of: self)
    
    // MARK: UI Components
    lazy var gifButton = InputViewButton(icon: #imageLiteral(resourceName: "actionsheet_gif_black"), delegate: self, hasOpaqueBackground: true)
    lazy var gifButtonContainer = container(for: gifButton)
    lazy var documentButton = InputViewButton(icon: #imageLiteral(resourceName: "actionsheet_document_black"), delegate: self, hasOpaqueBackground: true)
    lazy var documentButtonContainer = container(for: documentButton)
    lazy var libraryButton = InputViewButton(icon: #imageLiteral(resourceName: "actionsheet_camera_roll_black"), delegate: self, hasOpaqueBackground: true)
    lazy var libraryButtonContainer = container(for: libraryButton)
    lazy var cameraButton = InputViewButton(icon: #imageLiteral(resourceName: "actionsheet_camera_black"), delegate: self, hasOpaqueBackground: true)
    lazy var cameraButtonContainer = container(for: cameraButton)
    lazy var mainButton = InputViewButton(icon: #imageLiteral(resourceName: "ic_plus_24"), delegate: self)
    lazy var mainButtonContainer = container(for: mainButton)
    
    // MARK: Lifecycle
    init(delegate: ExpandingAttachmentsButtonDelegate?) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        setUpViewHierarchy()
    }
    
    override init(frame: CGRect) {
        preconditionFailure("Use init(delegate:) instead.")
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("Use init(delegate:) instead.")
    }
    
    private func setUpViewHierarchy() {
        backgroundColor = .clear
        // GIF button
        addSubview(gifButtonContainer)
        gifButtonContainer.alpha = 0
        // Document button
        addSubview(documentButtonContainer)
        documentButtonContainer.alpha = 0
        // Library button
        addSubview(libraryButtonContainer)
        libraryButtonContainer.alpha = 0
        // Camera button
        addSubview(cameraButtonContainer)
        cameraButtonContainer.alpha = 0
        // Main button
        addSubview(mainButtonContainer)
        // Constraints
        mainButtonContainer.pin(to: self)
        gifButtonContainer.center(.horizontal, in: self)
        documentButtonContainer.center(.horizontal, in: self)
        libraryButtonContainer.center(.horizontal, in: self)
        cameraButtonContainer.center(.horizontal, in: self)
        [ gifButtonContainerBottomConstraint, documentButtonContainerBottomConstraint, libraryButtonContainerBottomConstraint, cameraButtonContainerBottomConstraint ].forEach {
            $0.isActive = true
        }
    }
    
    // MARK: Animation
    private func expandOrCollapse() {
        if isExpanded {
            let expandedButtonSize = InputViewButton.expandedSize
            let spacing: CGFloat = 4
            cameraButtonContainerBottomConstraint.constant = -1 * (expandedButtonSize + spacing)
            libraryButtonContainerBottomConstraint.constant = -2 * (expandedButtonSize + spacing)
            documentButtonContainerBottomConstraint.constant = -3 * (expandedButtonSize + spacing)
            gifButtonContainerBottomConstraint.constant = -4 * (expandedButtonSize + spacing)
            UIView.animate(withDuration: 0.25) {
                [ self.gifButtonContainer, self.documentButtonContainer, self.libraryButtonContainer, self.cameraButtonContainer ].forEach {
                    $0.alpha = 1
                }
                self.layoutIfNeeded()
            }
        } else {
            [ gifButtonContainerBottomConstraint, documentButtonContainerBottomConstraint, libraryButtonContainerBottomConstraint, cameraButtonContainerBottomConstraint ].forEach {
                $0.constant = 0
            }
            UIView.animate(withDuration: 0.25) {
                [ self.gifButtonContainer, self.documentButtonContainer, self.libraryButtonContainer, self.cameraButtonContainer ].forEach {
                    $0.alpha = 0
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Interaction
    func handleInputViewButtonTapped(_ inputViewButton: InputViewButton) {
        if inputViewButton == gifButton { delegate?.handleGIFButtonTapped(); isExpanded = false }
        if inputViewButton == documentButton { delegate?.handleDocumentButtonTapped(); isExpanded = false }
        if inputViewButton == libraryButton { delegate?.handleLibraryButtonTapped(); isExpanded = false }
        if inputViewButton == cameraButton { delegate?.handleCameraButtonTapped(); isExpanded = false }
        if inputViewButton == mainButton { isExpanded = !isExpanded }
    }
    
    // MARK: Convenience
    private func container(for button: InputViewButton) -> UIView {
        let result = UIView()
        result.addSubview(button)
        result.set(.width, to: InputViewButton.expandedSize)
        result.set(.height, to: InputViewButton.expandedSize)
        button.center(in: result)
        return result
    }
}

// MARK: Delegate
protocol ExpandingAttachmentsButtonDelegate : class {

    func handleGIFButtonTapped()
    func handleDocumentButtonTapped()
    func handleLibraryButtonTapped()
    func handleCameraButtonTapped()
}
