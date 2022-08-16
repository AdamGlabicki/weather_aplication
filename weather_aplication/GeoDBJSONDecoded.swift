import UIKit

struct GeoDBJSONDecoded: Decodable {
    let data: [CityInfo]
    let links: [Link]?
    let metadata: Metadata
}
