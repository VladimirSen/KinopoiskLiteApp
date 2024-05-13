import UIKit
import SnapKit

final class TableViewController: UIViewController {
    var presenter: TablePresenterProtocol = TablePresenter()
    var presenterInfo: DetailPresenterProtocol = DetailPresenter(viewInfo: DetailViewController(),
                                                                 networkService: ServiceInfo())
    let cell = "Cell"
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl: UIRefreshControl?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        tableView.backgroundColor = .white
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupViews()
        setupConstraints()
        setupActivityIndicator()
        addRefreshControl()
        presenter.setView(self)
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .gray
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }

    @objc func refreshList() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(25)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(75)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
        }
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.model?.films?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell) as? Cell
        let film = presenter.model?.films?[indexPath.row]
        cell?.mainLabel.text = film?.nameRu
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            guard let urlImage = URL(string: (self.presenter.model?.films?[indexPath.row].posterUrl)!) else { return }
            URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
                if error != nil {
                    print("error")
                }
                if response != nil {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        cell?.imageLabel.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell ?? UITableViewCell()
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        let url = "https://kinopoiskapiunofficial.tech/api/v2.2/films/"
        let urlString = "\(url)\(presenter.model?.films?[indexPath.row].filmId ?? 0)"
        presenterInfo.networkService.request(urlString: urlString) { [weak self] (detailViewModel, error) in
            if error != nil {
                print("error")
            }
            self?.presenterInfo.modelInfo = detailViewModel
        }
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async { [self] in
            guard let urlImage = URL(string:
            (presenter.model?.films?[indexPath.row].posterUrl) ?? "")
            else { return }
            URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
                if error != nil {
                    print("error")
                }
                if response != nil {
                    guard let data = data else { return }
                DispatchQueue.main.async { [self] in
                detailVC.image.image = UIImage(data: data)
                detailVC.labelNameRu.text = "\(presenterInfo.modelInfo?.nameRu ?? "")"
                detailVC.labelNameOriginal.text = "\(presenterInfo.modelInfo?.nameOriginal ?? "")"
                detailVC.labelKinopoiskRating.text = "Kinopoisk\n\n\(presenterInfo.modelInfo?.ratingKinopoisk ?? 0.0)"
                detailVC.labelImdbRating.text = "IMDB\n\n\(presenterInfo.modelInfo?.ratingImdb ?? 0.0)"
                detailVC.labelDescription.text = "\(presenterInfo.modelInfo?.description ?? "")"
                detailVC.labelYear.text = "Год производства\n\(presenterInfo.modelInfo?.year ?? 0)"
                detailVC.labelfilmLength.text = "Продолжительность\n\(presenterInfo.modelInfo?.filmLength ?? 0) мин."
                }
            }
            }.resume()
        }
        self.present(detailVC, animated: true)
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        presenter.tapSeachBar(searchText: searchBar.text ?? "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.presenter.model = nil
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
        }
    }

extension TableViewController: TableViewProtocol {
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }
}
