import Foundation
import RealmSwift
// swiftlint:disable force_try
final class StorageService {
    private let kLastSearchesKey = "lastSearches"

    static let sharedInstance = StorageService()

    let realm = try! Realm()
    lazy var citiesInfoArray: Results<CityInfoObject> = { self.realm.objects(CityInfoObject.self) }()

    func getCitiesInfo(failure: @escaping ((Error) -> Void)) -> [CityInfo] {
        var cityInfoArray: [CityInfo] = []
        citiesInfoArray = citiesInfoArray.distinct(by: ["city"])
        for index in citiesInfoArray {
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
        citiesInfoArray = realm.objects(CityInfoObject.self)
        citiesInfoArray = citiesInfoArray.distinct(by: ["city"])
    }
}
