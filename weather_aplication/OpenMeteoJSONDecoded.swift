import UIKit

struct OpenMeteoJSONDecoded: Decodable {
    let latitude: Double
    let longitude: Double
    let generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: HourlyUnits
    let hourly: HourlyWeatherData

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
    }
}
