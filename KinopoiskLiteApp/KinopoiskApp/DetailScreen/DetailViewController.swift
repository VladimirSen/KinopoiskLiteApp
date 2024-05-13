import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var image = UIImageView(frame: CGRect(x: 30, y: 40, width: 150, height: 200))
    
    lazy var labelKinopoiskRating: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelImdbRating: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelNameRu: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelNameOriginal: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 10
        return label
    }()
    
    lazy var labelYear: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var labelfilmLength: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(labelKinopoiskRating)
        stackView.addArrangedSubview(labelImdbRating)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(image)
        view.addSubview(stackView)
        view.addSubview(labelNameRu)
        view.addSubview(labelNameOriginal)
        view.addSubview(labelDescription)
        view.addSubview(labelYear)
        view.addSubview(labelfilmLength)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(250)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(180)
        }
        labelNameRu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(270)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(30)
        }
        labelNameOriginal.snp.makeConstraints { make in
            make.top.equalTo(labelNameRu.snp.bottom).inset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(30)
        }
        labelDescription.snp.makeConstraints { make in
            make.top.equalTo(labelNameOriginal.snp.bottom).inset(-20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(30)
        }
        labelYear.snp.makeConstraints { make in
            make.top.equalTo(labelDescription.snp.bottom).inset(-20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
        }
        labelfilmLength.snp.makeConstraints { make in
            make.top.equalTo(labelYear.snp.bottom).inset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
        }
    }
}

extension DetailViewController: DetailViewProtocol {}
