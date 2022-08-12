import UIKit

struct OpenMeteoJSON: Decodable {
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

    init(latitude: Double, longitude: Double, generationtimeMS: Double, utcOffsetSeconds: Int, timezone: String, timezoneAbbreviation: String, elevation: Int, hourlyUnits: HourlyUnits, hourly: HourlyWeatherData) {
        self.latitude = latitude
        self.longitude = longitude
        self.generationtimeMS = generationtimeMS
        self.utcOffsetSeconds = utcOffsetSeconds
        self.timezone = timezone
        self.timezoneAbbreviation = timezoneAbbreviation
        self.elevation = elevation
        self.hourlyUnits = hourlyUnits
        self.hourly = hourly
    }
}

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
