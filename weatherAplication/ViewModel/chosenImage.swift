import UIKit

extension CustomTableViewCell {

    func chosenImage(weatherCode: WeatherCodes) -> UIImage? {
        let cloudAndSunImage = UIImage(systemName: "cloud.sun.fill", withConfiguration: cloudAndSunConfig)
        let snowImage = UIImage(systemName: "cloud.snow.fill", withConfiguration: precipitationConfig)
        let rainImage = UIImage(systemName: "cloud.rain.fill", withConfiguration: precipitationConfig)
        let heavyRainImage = UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: precipitationConfig)
        let drizzleImage = UIImage(systemName: "cloud.drizzle.fill", withConfiguration: precipitationConfig)
        let boltImage = UIImage(systemName: "cloud.bolt.fill", withConfiguration: boltConfig)

        switch weatherCode {
        case .sun:
            return sunImage?.withTintColor(UIColor.darkYellowColor(), renderingMode: .alwaysOriginal)
        case .cloudAndSun:
            return cloudAndSunImage
        case .bigCloudAndSun:
            return cloudAndSunImage
        case .cloud:
            return cloudImage?.withTintColor(UIColor.cloudColor(), renderingMode: .alwaysOriginal)
        case .smallDrizzle, .drizzle, .bigDrizzle, .freezingDrizzle, .freezingBigDrizzle:
            return drizzleImage
        case .smallRain, .rain, .freezingRain:
            return rainImage
        case .heavyRain, .bigHeavyRain, .freezingSmallHeavyRain, .freezingHeavyRain, .freezingBigHeavyRain:
            return heavyRainImage
        case .smallSnow, .snow, .bigSnow, .heavySnow, .freezingSmallSnow, .freezingSnow:
            return snowImage
        case .smallStorm, .storm, .heavyStorm:
            return boltImage
        }
    }

}
