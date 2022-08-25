import Foundation
import UIKit

class ShowWeatherViewModel {

    var delegate: ShowWeatherDelegate?
    let apiClient = APIClient.sharedInstance

    var weatherDataArray: [WeatherData] = []
    var dateString: String = ""

    func getWeather(data: CityInfo) {
        let latitude = data.latitude
        let longitude = data.longitude

        apiClient.searchWeather(latitude: latitude, longitude: longitude, completion: { [weak self] weatherInfo, date -> Void in
            self?.weatherDataArray = []
            self?.dateString = ""
            self?.dateString = date
            self?.weatherDataArray = weatherInfo
            self?.delegate?.weatherLoaded(weatherInfo: weatherInfo, date: date)
            }, failure: { weatherError in
                let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.delegate?.wetherLoadingError(alert: alert)
            })
    }
}

protocol ShowWeatherDelegate: AnyObject {
    func weatherLoaded(weatherInfo: [WeatherData], date: String)
    func wetherLoadingError(alert: UIAlertController)
}

extension ShowWeatherViewModel: ShowWeatherViewModelContract {
func getWeatherDataArray() -> [WeatherData] {
    return weatherDataArray
}

func getDate() -> String {
    return dateString
}

}
