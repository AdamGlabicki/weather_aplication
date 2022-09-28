import Foundation
import RealmSwift

// swiftlint:disable force_try
final class StorageService {
    private let kLastSearchesKey = "lastSearches"

    static let sharedInstance = StorageService()

    private let realm = try! Realm()

    func getCitiesInfo(failure: @escaping ((Error) -> Void)) -> [CityInfo] {
        var cityInfoArray: [CityInfo] = []
        for index in realm.objects(CityInfoObject.self).distinct(by: ["city"]) {
        let cities = CityInfo(persistedObject: index)
            cityInfoArray.append(cities)
        }
        return cityInfoArray
    }

    func addRecentlySearchedCity(cityInfo: CityInfo, failure: @escaping ((Error) -> Void)) {
        do {
            try realm.write {
                let city = cityInfo.persistedObject()
                realm.add(city)
            }
        } catch {
            failure(error)
        }
    }
}
