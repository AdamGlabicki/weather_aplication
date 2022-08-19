import SnapKit
import UIKit

final class ClientAPI {
    private let urlGeoDBString: String = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?"
    static let sharedInstance: ClientAPI = {
        let instance = ClientAPI()
        return instance
    }()

    private init() {}

    func searchCities(searchTerm: String, view: UIViewController, completion: @escaping (_ result: [CityInfo]) -> Void) {
        guard let queryURL = URL(string: urlGeoDBString + "&namePrefix=" + searchTerm + "&sort=-population") else { return }
        let session = URLSession.shared

        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in

            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                view.present(alert, animated: true)
            }

            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(GeoDBDecoded.self, from: data)
                        completion(self?.takeDataFromJson(jsonResult: jsonResult) ?? [])
                    } catch let error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        view.present(alert, animated: true)
                    }
                }
            }
        }).resume()
    }

    func takeDataFromJson(jsonResult: GeoDBDecoded) -> [CityInfo] {
        var cityNames: [CityInfo] = []
        cityNames = jsonResult.data.map { $0 }
        return cityNames
    }
}
