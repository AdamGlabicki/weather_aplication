import Foundation
import UIKit

class ShowWeatherViewModel {

    var delegate: ShowWeatherDelegate?

    func chosenImage(weatherCode: WeatherCodes) -> UIImage? {

        delegate?.chosenImage(weatherCode: weatherCode)

    }
}

protocol ShowWeatherDelegate: AnyObject {
    func chosenImage(weatherCode: WeatherCodes) -> UIImage?
}
