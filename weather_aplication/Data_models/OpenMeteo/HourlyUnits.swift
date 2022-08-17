import UIKit

struct HourlyUnits: Decodable {
    let time: String
    let temperature: String
    let surfacePressure: String
    let weathercode: String
    let windspeed: String

    enum CodingKeys: String, CodingKey {
        case time, weathercode
        case temperature = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case windspeed = "windspeed_10m"
    }
}
