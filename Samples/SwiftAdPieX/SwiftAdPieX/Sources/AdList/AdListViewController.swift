import UIKit

final class AdListViewController: UIViewController {

    // MARK: - UI Components

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Properties

    private let items: [AdMenuItem] = [
        AdMenuItem(
            title: "Interstitial Ad - Image, Portrait",
            subtitle: "전면 광고 - 이미지, 세로",
            type: .interstitial("697c1394a56addbb35024c04")
        ),
        AdMenuItem(
            title: "Interstitial Ad - Image, Landscape",
            subtitle: "전면 광고 - 이미지, 가로",
            type: .interstitial("697c13b7a56addbb35024c06")
        ),

        AdMenuItem(
            title: "Interstitial Ad - Video, Portrait",
            subtitle: "전면 광고 - 비디오, 세로",
            type: .interstitial("697c173da56addbb35024c0d")
        ),
        AdMenuItem(
            title: "Interstitial Ad - Video, Landscape",
            subtitle: "전면 광고 - 비디오, 가로",
            type: .interstitial("697c1792a56addbb35024c0f")
        ),

        AdMenuItem(
            title: "Rewarded Ad - Portrait",
            subtitle: "리워드 광고 - 세로",
            type: .rewarded("697c1d6ea56addbb35024c29")
        ),
        AdMenuItem(
            title: "Rewarded Ad - Landscape",
            subtitle: "리워드 광고 - 가로",
            type: .rewarded("697c1d94a56addbb35024c2b")
        ),

        AdMenuItem(
            title: "Native Ad",
            subtitle: "네이티브 광고",
            type: .native("697c1c4fa56addbb35024c27")
        )
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    // MARK: - UI Setup

    private func setUI() {
        view.backgroundColor = .white

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(AdListCell.self, forCellReuseIdentifier: "AdListCell")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AdListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "AdListCell",
            for: indexPath
        ) as? AdListCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(data: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedItem = items[indexPath.row]
        let destinationVC = selectedItem.type.viewController
        destinationVC.title = selectedItem.title

        if let navigationController = navigationController {
            navigationController.pushViewController(destinationVC, animated: true)
        } else {
            present(destinationVC, animated: true)
        }
    }
}
