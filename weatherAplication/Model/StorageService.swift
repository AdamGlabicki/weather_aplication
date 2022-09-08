import Foundation

final class StorageService {
    private let klastSearchesKey = "lastSearches"

    static let sharedInstance = StorageService()

    func getCitiesInfo(failure: @escaping ((Error) -> Void)) -> [CityInfo] {
        var citiesInfoArray: [CityInfo] = []
        if let data = UserDefaults.standard.data(forKey: klastSearchesKey) {
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
        var citiesInfoArray: [CityInfo] = []
        if let dataReceived = UserDefaults.standard.data(forKey: klastSearchesKey) {
            do {
                citiesInfoArray = try PropertyListDecoder().decode([CityInfo].self, from: dataReceived)
            } catch {
                failure(error)
            }
            citiesInfoArray.append(cityInfo)
        }
        if let dataToSend = try? PropertyListEncoder().encode(citiesInfoArray) {
            UserDefaults.standard.set(dataToSend, forKey: klastSearchesKey)
        }
    }
}
