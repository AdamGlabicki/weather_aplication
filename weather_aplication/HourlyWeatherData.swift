import UIKit

struct HourlyWeatherData: Decodable {
    let time: [String]
    let temperature2M: [Double]
    let surfacePressure: [Double]
    let weathercode: [Int]
    let windspeed10M: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case weathercode
        case windspeed10M = "windspeed_10m"
    }

    init(time: [String], temperature2M: [Double], surfacePressure: [Double], weathercode:[Int], windspeed10M: [Double]) {
        self.time = time
        self.temperature2M = temperature2M
        self.surfacePressure = surfacePressure
        self.weathercode = weathercode
        self.windspeed10M = windspeed10M
    }
}
