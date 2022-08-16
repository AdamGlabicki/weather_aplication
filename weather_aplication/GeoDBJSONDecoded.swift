import UIKit

struct GeoDBDecoded: Decodable {
    let data: [CityInfo]
    let links: [Link]?
    let metadata: Metadata
}
