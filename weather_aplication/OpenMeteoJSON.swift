import UIKit
import SnapKit

class OpenMeteoJSON: Decodable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: HourlyUnits
    let hourly: Hourly

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

    init(latitude: Double, longitude: Double, generationtimeMS: Double, utcOffsetSeconds: Int, timezone: String, timezoneAbbreviation: String, elevation: Int, hourlyUnits: HourlyUnits, hourly: Hourly) {
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

class Hourly: Decodable {
    let time: [String]
    let temperature2M, surfacePressure, windspeed10M: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case windspeed10M = "windspeed_10m"
    }

    init(time: [String], temperature2M: [Double], surfacePressure: [Double], windspeed10M: [Double]) {
        self.time = time
        self.temperature2M = temperature2M
        self.surfacePressure = surfacePressure
        self.windspeed10M = windspeed10M
    }
}

class HourlyUnits: Decodable {
    let time, temperature2M, surfacePressure, windspeed10M: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case surfacePressure = "surface_pressure"
        case windspeed10M = "windspeed_10m"
    }

    init(time: String, temperature2M: String, surfacePressure: String, windspeed10M: String) {
        self.time = time
        self.temperature2M = temperature2M
        self.surfacePressure = surfacePressure
        self.windspeed10M = windspeed10M
    }
}
