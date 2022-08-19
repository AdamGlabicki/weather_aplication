import SnapKit
import UIKit

final class APIClient {
    private var kElementsToShow = 24
    private let kCharsToDrop = 11
    private let urlGeoDBString: String = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?"
    private let urlOpenMeteoString: String = "https://api.open-meteo.com/v1/forecast?"
    static let sharedInstance: APIClient = {
        let instance = APIClient()
        return instance
    }()

    private init() {}

    func searchWeather(latitude: Double, longitude: Double, completion: @escaping (_ result: Result<[WeatherData], Error>, _ date: String) -> Void) {
        guard let queryURL = URL(string: urlOpenMeteoString + "latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,surface_pressure,weathercode,windspeed_10m") else { return }
        let session = URLSession.shared

        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in

            if error != nil {
                guard let error = error else { return }
                completion(.failure(error), "")
            }

            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(OpenMeteoDecoded.self, from: data)
                        guard let weatherData = self?.takeDataFromJson(jsonResult: jsonResult) else { return }
                        completion(.success(weatherData.data), weatherData.date)
                    } catch let error {
                        completion(.failure(error), "")
                    }
                }
            }

        }).resume()
    }

    func takeDataFromJson(jsonResult: OpenMeteoDecoded) -> (data: [WeatherData], date: String) {
        var dataArray: [WeatherData] = []
        var date: String = ""
        if jsonResult.hourly.time.count >= kElementsToShow,
           jsonResult.hourly.temperature.count >= kElementsToShow,
           jsonResult.hourly.surfacePressure.count >= kElementsToShow,
           jsonResult.hourly.windspeed.count >= kElementsToShow,
           jsonResult.hourly.weathercode.count >= kElementsToShow {
            date = String(jsonResult.hourly.time[0].prefix(kCharsToDrop - 1))
            for index in 0...(kElementsToShow - 1) {
                dataArray.append(WeatherData(hour: String(jsonResult.hourly.time[index].dropFirst(kCharsToDrop)),
                                             temperature: jsonResult.hourly.temperature[index],
                                             pressure: jsonResult.hourly.surfacePressure[index],
                                             windSpeed: jsonResult.hourly.windspeed[index],
                                             weatherCode: jsonResult.hourly.weathercode[index]))
            }
            return (dataArray, date)
        }
        return (dataArray, date)
    }

    func searchCities(searchTerm: String, completion: @escaping (_ result: Result<[CityInfo], Error>) -> Void) {
        guard let queryURL = URL(string: urlGeoDBString + "&namePrefix=" + searchTerm + "&sort=-population") else { return }
        let session = URLSession.shared

        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in

            if error != nil {
                guard let error = error else { return }
                completion(.failure(error))
            }

            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(GeoDBDecoded.self, from: data)
                        completion(.success(self?.takeDataFromGeoDBJson(jsonResult: jsonResult) ?? []))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }).resume()
    }

    func takeDataFromGeoDBJson(jsonResult: GeoDBDecoded) -> [CityInfo] {
        var cityNames: [CityInfo] = []
        cityNames = jsonResult.data.map { $0 }
        return cityNames
    }
}
