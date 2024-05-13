import UIKit
import SnapKit

class Cell: UITableViewCell {

    var imageLabel = UIImageView()

    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageLabel)
        contentView.addSubview(mainLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(_ viewModel: CellModel) {
        mainLabel.text = viewModel.mainLabel
    }
    private func setupConstraints() {
        imageLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(60)
            make.top.equalTo(10)
        }
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(80)
            make.trailing.equalTo(-8)
        }
    }
}
