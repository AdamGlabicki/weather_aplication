import UIKit

struct HourlyUnits: Decodable {
    let time: String
    let temperature2M: String
    let surfacePressure: String
    let weathercode: String
    let windspeed10M: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case weathercode
        case windspeed10M = "windspeed_10m"
    }

    init(time: String, temperature2M: String, surfacePressure: String, weathercode: String, windspeed10M: String) {
        self.time = time
        self.temperature2M = temperature2M
        self.surfacePressure = surfacePressure
        self.weathercode = weathercode
        self.windspeed10M = windspeed10M
    }
}
