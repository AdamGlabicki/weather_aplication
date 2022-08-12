import UIKit

struct CityInfo: Decodable {
    let id: Int
    let wikiDataID: String?
    let type: String?
    let city: String?
    let name: String?
    let country: String?
    let countryCode: String?
    let region: String?
    let regionCode: String?
    let latitude, longitude: Double?
    let population: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case wikiDataID = "wikiDataId"
        case type, city, name, country, countryCode, region, regionCode, latitude, longitude, population
    }

    init(id: Int, wikiDataID: String?, type: String?, city: String?, name: String?, country: String?, countryCode: String?, region: String?, regionCode: String?, latitude: Double?, longitude: Double?, population: Int?) {
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
