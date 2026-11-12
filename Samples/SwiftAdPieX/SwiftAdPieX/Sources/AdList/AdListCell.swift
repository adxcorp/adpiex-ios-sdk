import UIKit

final class AdListCell: UITableViewCell {

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "AdPieX"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 50/255, green: 80/255, blue: 120/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(logoLabel)
        containerView.addSubview(textStackView)

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            logoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logoLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoLabel.widthAnchor.constraint(equalToConstant: 60),

            textStackView.leadingAnchor.constraint(equalTo: logoLabel.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    // MARK: - Configuration

    func configure(data: AdMenuItem) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}
