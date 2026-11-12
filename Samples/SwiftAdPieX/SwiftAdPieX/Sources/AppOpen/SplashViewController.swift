import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private var started: Bool = false
    private var sdkReady: Bool = false
    private var finished: Bool = false
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !started else { return }
        started = true
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.waitForAdPieSDKInitialization { [weak self] initialized in
            guard let self = self else { return }
            guard initialized else {
                self.showMain()
                return
            }
            self.sdkReady = true
            self.showLoadingIfNeeded()
        }
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "AdPieX\nSplash"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Set Notification
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }

    @objc private func didBecomeActive() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoadingIfNeeded()
        }
    }
    
    // MARK: - Navigate

    private func showLoadingIfNeeded() {
        guard sdkReady, !finished, view.window != nil,
              UIApplication.shared.applicationState == .active,
              view.window?.windowScene?.activationState == .foregroundActive
        else {
            return
        }
        
        finished = true
        navigationController?.setViewControllers([SplashLoadingViewController()], animated: false)
    }

    private func showMain() {
        guard !finished else { return }
        finished = true
        navigationController?.setViewControllers([AdListViewController()], animated: false)
    }
}
