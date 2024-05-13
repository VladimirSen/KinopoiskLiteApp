import UIKit

struct TableModel: Codable {
    let films: [Film]?
}

struct Film: Codable {
    let filmId: Int
    let nameRu: String?
    let posterUrl: String?
}

struct CellModel {
    let imageLabel: UIImageView
    let mainLabel: String
}
