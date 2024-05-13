protocol TableViewProtocol: AnyObject {
    func stopActivityIndicator()
}

protocol TablePresenterProtocol: AnyObject {
    var model: TableModel? { get set }
    func setView(_ view: TableViewProtocol)
    func tapSeachBar(searchText: String)
}

final class TablePresenter: TablePresenterProtocol {
    weak var view: TableViewProtocol!
    var model: TableModel?
    private var networkService: NetworkServiceProtocol = Service()

    func setView(_ view: TableViewProtocol) {
        self.view = view
    }
    func tapSeachBar(searchText: String) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(searchText)"
        networkService.request(urlString: urlString) { [weak self] (TableModel, error) in
            if error != nil {
                print("error")
            }
            self?.model = TableModel
            self?.view?.stopActivityIndicator()
        }
    }
}
