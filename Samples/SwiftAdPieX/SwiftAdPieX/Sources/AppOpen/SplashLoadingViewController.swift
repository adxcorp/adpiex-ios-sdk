import UIKit
import AdPieXFramework

final class SplashLoadingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var requested: Bool = false
    private var appOpenAdService: APAppOpenAdService?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNotification()
        setAppOpenAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAppOpenAdIfNeeded()
    }

    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "AdPieX\nLoading..."
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemBlue
        view.addSubview(spinner)
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16)
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
            self?.presentAppOpenAdIfNeeded()
        }
    }
    
    // MARK: - App Open Ad
    
    private func setAppOpenAd() {
        appOpenAdService = APAppOpenAdService.sharedInstance()
        appOpenAdService?.delegate = self
    }

    private func presentAppOpenAdIfNeeded() {
        guard !requested, view.window != nil,
              UIApplication.shared.applicationState == .active,
              view.window?.windowScene?.activationState == .foregroundActive
        else {
            return
        }
        requested = true

        appOpenAdService?.present("6af43f8fbbfa519f16c5f264", viewController: self) { value in
            print("[AppOpen] paidEvent, eCPM: \(value)")
        }
    }
    
    // MARK: - Navigate

    private func waitAndShowMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.showMain()
        }
    }

    private func showMain() {
        guard let navigationController = navigationController,
              navigationController.viewControllers.first === self
        else {
            return
        }
        navigationController.setViewControllers([AdListViewController()], animated: false)
    }
}

// MARK: - APAppOpenAdDelegate

extension SplashLoadingViewController: APAppOpenAdDelegate {
    func appOpenAdDidDismissScreen(_ ad: APAppOpenAdService) {
        showMain()
    }

    func appOpenAdDidFail(toShowAd ad: APAppOpenAdService, withError error: Error) {
        guard (error as NSError).userInfo[APAppOpenAdDuplicateRequestKey] as? Bool != true else { return }
        print("[AppOpen] 표시 실패: \(error)")
        waitAndShowMain()
    }
}
