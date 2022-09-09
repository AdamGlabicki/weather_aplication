import SnapKit
import UIKit

final class APIClient {
    private let kElementsToShow = 24
    private let kCharsToDrop = 11
    private let urlGeoDBString: String = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?"
    private let urlOpenMeteoString: String = "https://api.open-meteo.com/v1/forecast?"
    static let sharedInstance = APIClient()

    private init() {}

    func searchWeather(latitude: Double, longitude: Double, completion: @escaping (_ result: [WeatherData], _ date: String) -> Void, failure: @escaping ((WeatherError) -> Void)) {
        guard let queryURL = URL(string: urlOpenMeteoString + "latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weathercode,surface_pressure,windspeed_10m") else { return }
        let session = URLSession.shared

        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in

            if error != nil {
                failure(WeatherError.invalidConnection)
            }

            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(OpenMeteoDecoded.self, from: data)
                        guard let weatherData = self?.takeDataFromJson(jsonResult: jsonResult) else { return }
                        completion((weatherData.data), weatherData.date)
                    } catch {
                        failure(WeatherError.decoding)
                    }
                }
            }

        }).resume()
    }

    func takeDataFromJson(jsonResult: OpenMeteoDecoded) -> (data: [WeatherData], date: String) {
        var dataArray: [WeatherData] = []
        var date: String = ""
        let data = jsonResult.hourly
        date = String(data.time[0].prefix(kCharsToDrop - 1))
        let hour = Array(Array(data.time.map { String($0.dropFirst(kCharsToDrop)) }).prefix(kElementsToShow))
        let temperature = Array(data.temperature.prefix(kElementsToShow)).compactMap { $0 }
        let pressure = Array(data.surfacePressure.prefix(kElementsToShow)).compactMap { $0 }
        let windSpeed = Array(data.windSpeed.prefix(kElementsToShow)).compactMap { $0 }
        let weatherCode = Array(data.weatherCode.prefix(kElementsToShow)).compactMap { $0 }
        for index in 0...(kElementsToShow - 1) {
            dataArray.append(WeatherData(hour: hour[index],
                                         temperature: temperature[index],
                                         pressure: pressure[index],
                                         windSpeed: windSpeed[index],
                                         weatherCode: weatherCode[index]))
        }
        return (dataArray, date)
    }

    func searchCities(searchTerm: String, completion: @escaping (_ result: [CityInfo]) -> Void, failure: @escaping ((WeatherError) -> Void)) {
        guard let queryURL = URL(string: urlGeoDBString + "&namePrefix=" + searchTerm + "&sort=-population") else { return }
        let session = URLSession.shared

        session.dataTask(with: queryURL, completionHandler: { data, response, error -> Void in

            if error != nil {
                failure(WeatherError.invalidConnection)
            }

            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(GeoDBDecoded.self, from: data)
                        completion(jsonResult.data.map { $0 })
                    } catch {
                        failure(WeatherError.decoding)
                    }
                }
            }
        }).resume()
    }

}

enum WeatherError: Error {
    case invalidConnection, decoding
}

enum WeatherCodes: Int {
    case sun = 0
    case cloudAndSun = 1
    case bigCloudAndSun = 2
    case cloud = 3
    case smallDrizzle = 51
    case drizzle = 53
    case bigDrizzle = 55
    case freezingDrizzle = 56
    case freezingBigDrizzle = 57
    case smallRain = 61
    case rain = 63
    case freezingRain = 66
    case heavyRain = 65
    case bigHeavyRain = 67
    case freezingSmallHeavyRain = 80
    case freezingHeavyRain = 81
    case freezingBigHeavyRain = 82
    case smallSnow = 71
    case snow = 73
    case bigSnow = 75
    case heavySnow = 77
    case freezingSmallSnow = 85
    case freezingSnow = 86
    case smallStorm = 95
    case storm = 96
    case heavyStorm = 99

    var image: UIImage? {
        let cloudAndSunConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), UIColor.darkYellowColor()])
        let precipitationConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), .blue])
        let boltConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), UIColor.darkYellowColor()])

        let cloudAndSunImage = UIImage(systemName: "cloud.sun.fill", withConfiguration: cloudAndSunConfig)
        let snowImage = UIImage(systemName: "cloud.snow.fill", withConfiguration: precipitationConfig)
        let rainImage = UIImage(systemName: "cloud.rain.fill", withConfiguration: precipitationConfig)
        let heavyRainImage = UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: precipitationConfig)
        let drizzleImage = UIImage(systemName: "cloud.drizzle.fill", withConfiguration: precipitationConfig)
        let boltImage = UIImage(systemName: "cloud.bolt.fill", withConfiguration: boltConfig)
        let sunImage = UIImage(systemName: "sun.max.fill")
        let cloudImage = UIImage(systemName: "cloud.fill")

        switch self {
        case .sun:
            return sunImage?.withTintColor(UIColor.darkYellowColor(), renderingMode: .alwaysOriginal)
        case .cloudAndSun:
            return cloudAndSunImage
        case .bigCloudAndSun:
            return cloudAndSunImage
        case .cloud:
            return cloudImage?.withTintColor(UIColor.cloudColor(), renderingMode: .alwaysOriginal)
        case .smallDrizzle, .drizzle, .bigDrizzle, .freezingDrizzle, .freezingBigDrizzle:
            return drizzleImage
        case .smallRain, .rain, .freezingRain:
            return rainImage
        case .heavyRain, .bigHeavyRain, .freezingSmallHeavyRain, .freezingHeavyRain, .freezingBigHeavyRain:
            return heavyRainImage
        case .smallSnow, .snow, .bigSnow, .heavySnow, .freezingSmallSnow, .freezingSnow:
            return snowImage
        case .smallStorm, .storm, .heavyStorm:
            return boltImage
        }
    }
}
