import UIKit

struct HourlyWeatherData: Decodable {
    let time: [String]
    let temperature: [Double]
    let surfacePressure: [Double]
    let weathercode: [Int]
    let windspeed: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case weathercode
        case windspeed = "windspeed_10m"
    }
}
