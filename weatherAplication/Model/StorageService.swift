import Foundation

final class StorageService {
    var citiesInfoArray: [CityInfo] = []
    let lastSearchesKey = "lastSearchesKey"

    static let sharedInstance: StorageService = {
        let instance = StorageService()
        return instance
    }()

    func getCitiesInfo(failure: @escaping ((Error) -> Void)) -> [CityInfo] {
        if let data = UserDefaults.standard.data(forKey: lastSearchesKey) {
            do {
                citiesInfoArray = try PropertyListDecoder().decode([CityInfo].self, from: data)
            } catch {
                failure(error)
            }
        }
        citiesInfoArray = Array(Set(citiesInfoArray))
        return citiesInfoArray
    }

    func addRecentlySearchedCity(cityInfo: CityInfo, failure: @escaping ((Error) -> Void)) {
        if let dataRecived = UserDefaults.standard.data(forKey: lastSearchesKey) {
            do {
                citiesInfoArray = try PropertyListDecoder().decode([CityInfo].self, from: dataRecived)
            } catch {
                failure(error)
            }
            citiesInfoArray.append(cityInfo)
        }
        if let dataToSend = try? PropertyListEncoder().encode(citiesInfoArray) {
            UserDefaults.standard.set(dataToSend, forKey: lastSearchesKey)
        }
    }
}
