import Foundation

protocol ShowWeatherViewModelContract {
    var delegate: ShowWeatherDelegate? { get set }
    var weatherDataArray: [WeatherData] { get }
    var dateString: String { get }
    var cityName: String { get }

}

class ShowWeatherViewModel: ShowWeatherViewModelContract {

    var delegate: ShowWeatherDelegate?
    let apiClient = APIClient.sharedInstance

    var weatherDataArray: [WeatherData] = []
    var dateString: String = ""
    let longitude: Double
    let latitude: Double
    let cityName: String

    init(data: CityInfo) {
        self.latitude = data.latitude
        self.longitude = data.longitude
        self.cityName = data.city
        getWeather()
    }

    func getWeather() {
        apiClient.searchWeather(latitude: latitude, longitude: longitude, completion: { [weak self] weatherInfo, date -> Void in
            self?.dateString = date
            self?.weatherDataArray = weatherInfo
            self?.delegate?.weatherLoaded(weatherInfo: weatherInfo, date: date)
            }, failure: { weatherError in
                self.delegate?.showAlert(description: weatherError.localizedDescription)
            })
    }

}

protocol ShowWeatherDelegate: AnyObject {
    func weatherLoaded(weatherInfo: [WeatherData], date: String)
    func showAlert(description: String)
}
