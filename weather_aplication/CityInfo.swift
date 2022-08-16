import UIKit

struct CityInfo: Decodable {
    let id: Int
    let city: String?
    let latitude, longitude: Double?
}
