import UIKit
import AdPieXFramework

final class InterstitialAdViewController: UIViewController {

    // MARK: - UI Components

    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Ad", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return button
    }()
    private let showButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Ad", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return button
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Properties
    
    let slotId: String
    var interstitial: APInterstitial?
    
    // MARK: - Init
    
    init(slotId: String) {
        self.slotId = slotId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setInterstitialAd()
        setActions()
    }
    
    // MARK: - Set UI

    private func setUI() {
        stackView.addArrangedSubview(loadButton)
        stackView.addArrangedSubview(showButton)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Set Interstitial Ad
    
    private func setInterstitialAd() {
        interstitial = APInterstitial(slotId: self.slotId)
        interstitial?.delegate = self
    }
    
    // MARK: - Set Button Action
    
    private func setActions() {
        loadButton.addTarget(self, action: #selector(didTapLoadAdButton), for: .touchUpInside)
        showButton.addTarget(self, action: #selector(didTapShowAdButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoadAdButton() {
        // request interstitial ad
        interstitial?.load()
    }
    
    @objc private func didTapShowAdButton() {
        guard let interstitial = self.interstitial else { return }
        guard interstitial.isReady() == true else { return }
        interstitial.present(fromRootViewController: self)
    }
}

// MARK: - APInterstitialDelegate

extension InterstitialAdViewController: APInterstitialDelegate {
    func interstitialDidLoadAd(_ interstitial: APInterstitial!) {
        showToast(message: #function)
        print(#function)
    }
    
    func interstitialDidFail(toLoadAd interstitial: APInterstitial!, withError error: Error!) {
        showToast(message: #function)
        let nsError = error as NSError
        let errorMsg = String(
            format: "Error (code : %d, message : %@, date : %@)",
            Int32(nsError.code),
            nsError.localizedDescription,
            Date().description(with: Locale.current)
        )
        print("\(#function), \(errorMsg)")
    }
    
    func interstitialDidFail(toShowAd interstitial: APInterstitial!, withError error: (any Error)!) {
        showToast(message: #function)
        let nsError = error as NSError
        let errorMsg = String(
            format: "Error (code : %d, message : %@, date : %@)",
            Int32(nsError.code),
            nsError.localizedDescription,
            Date().description(with: Locale.current)
        )
        print("\(#function), \(errorMsg)")
    }
    
    func interstitialDidDismissScreen(_ interstitial: APInterstitial!) {
        showToast(message: #function)
        print(#function)
    }
    
    func interstitialWillPresentScreen(_ interstitial: APInterstitial!) {
        print(#function)
    }
    
    func interstitialWillDismissScreen(_ interstitial: APInterstitial!) {
        print(#function)
    }
    
    func interstitialWillLeaveApplication(_ interstitial: APInterstitial!) {
        print(#function)
    }
}
