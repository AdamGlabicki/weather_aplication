import Foundation


final class RecentlySearchedCities {
    static let sharedInstance: RecentlySearchedCities = {
        let instance = RecentlySearchedCities()
        return instance
    }()
}
