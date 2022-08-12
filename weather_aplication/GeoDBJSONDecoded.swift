import UIKit

struct GeoDBJSONDecoded: Decodable {
    let data: [CityInfo]
    let links: [Link]?
    let metadata: Metadata

    init(data: [CityInfo], links: [Link]?, metadata: Metadata) {
        self.data = data
        self.links = links
        self.metadata = metadata
    }
}
