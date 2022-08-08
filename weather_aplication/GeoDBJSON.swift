import UIKit
import SnapKit

class GeoDBJSON: Decodable {
    let data: [Datas]
    let links: [Link]
    let metadata: Metadata

    init(data: [Datas], links: [Link], metadata: Metadata) {
        self.data = data
        self.links = links
        self.metadata = metadata
    }
}

class Datas: Decodable {
    let id: Int
    let wikiDataID, type, city, name: String
    let country, countryCode, region, regionCode: String
    let latitude, longitude: Double
    let population: Int

    enum CodingKeys: String, CodingKey {
        case id
        case wikiDataID = "wikiDataId"
        case type, city, name, country, countryCode, region, regionCode, latitude, longitude, population
    }

    init(id: Int, wikiDataID: String, type: String, city: String, name: String, country: String, countryCode: String, region: String, regionCode: String, latitude: Double, longitude: Double, population: Int) {
        self.id = id
        self.wikiDataID = wikiDataID
        self.type = type
        self.city = city
        self.name = name
        self.country = country
        self.countryCode = countryCode
        self.region = region
        self.regionCode = regionCode
        self.latitude = latitude
        self.longitude = longitude
        self.population = population
    }
}

class Link: Decodable {
    let rel, href: String

    init(rel: String, href: String) {
        self.rel = rel
        self.href = href
    }
}

class Metadata: Decodable {
    let currentOffset, totalCount: Int

    init(currentOffset: Int, totalCount: Int) {
        self.currentOffset = currentOffset
        self.totalCount = totalCount
    }
}
