protocol DetailViewProtocol: AnyObject {}

protocol DetailPresenterProtocol: AnyObject {
    init(viewInfo: DetailViewProtocol, networkService: NetworkServiceInfoProtocol)
    var modelInfo: DetailModel? { get set }
    var networkService: NetworkServiceInfoProtocol! { get }
}

final class DetailPresenter: DetailPresenterProtocol {
    private let presenter: TablePresenterProtocol = TablePresenter()
    weak var viewInfo: DetailViewProtocol!
    var modelInfo: DetailModel?
    var networkService: NetworkServiceInfoProtocol!
    required init(viewInfo: DetailViewProtocol, networkService: NetworkServiceInfoProtocol) {
        self.viewInfo = viewInfo
        self.networkService = networkService
    }
}
