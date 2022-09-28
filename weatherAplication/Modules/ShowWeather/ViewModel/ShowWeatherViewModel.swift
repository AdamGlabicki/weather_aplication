import Combine
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
    private var cancellable: AnyCancellable?

    var weatherDataArray: [WeatherData] = []
    var dateString: String = ""
    let longitude: Double
    let latitude: Double
    let cityName: String

    init(data: CityInfo) {
        latitude = data.latitude
        longitude = data.longitude
        cityName = data.city

        getWeather()
    }

    func getWeather() {
        cancellable = apiClient.searchWeather(latitude: latitude, longitude: longitude)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case.failure(let error):
                        self.delegate?.showAlert(description: error.localizedDescription)
                    case.finished:
                        print("finished")
                    }
                }, receiveValue: {[weak self] weatherInfo, date in
                    self?.dateString = date
                    self?.weatherDataArray = weatherInfo
                    self?.delegate?.weatherLoaded(weatherInfo: weatherInfo, date: date)
                })
    }

}

protocol ShowWeatherDelegate: AnyObject {
    func weatherLoaded(weatherInfo: [WeatherData], date: String)
    func showAlert(description: String)
}
