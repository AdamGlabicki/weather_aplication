import UIKit

struct HourlyWeatherData: Decodable {
    let time: [String]
    let temperature: [Double?]
    let surfacePressure: [Double?]
    let weatherCode: [Int?]
    let windSpeed: [Double?]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weathercode"
        case temperature = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case windSpeed = "windspeed_10m"
    }
}
