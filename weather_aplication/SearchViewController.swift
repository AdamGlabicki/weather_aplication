import SnapKit
import UIKit

struct Location {
    public var city: String?
    public var longitude: Double?
    public var latitude: Double?
}

class SearchViewController: UIViewController {
    private let kTopMargin = 20
    
    private let cityNameTextField: UITextField = {
        let cityNameTextField = UITextField()
        cityNameTextField.placeholder = "city name"
        cityNameTextField.textAlignment = .center
        return cityNameTextField
    }()
    private let cityNamesTableView = UITableView()
    private var locationsArray: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        cityNameTextField.addTarget(self, action: #selector(loadCityNames), for: .editingChanged)
    }
    
    @objc func loadCityNames() {
        guard let cityName = cityNameTextField.text else { return }
        getCityName(fromCity: cityName, completion: {(location) -> Void in
            self.locationsArray = []
            self.locationsArray = location
            DispatchQueue.main.async {
                self.cityNamesTableView.reloadData()
            }
          })
    }
    
    func getCityName(fromCity cityName: String, completion: @escaping (_ result: [Location]) -> Void) {
        guard let queryURL =  URL(string:"http://geodb-free-service.wirefreethought.com/v1/geo/cities?&namePrefix=" + cityName + "&sort=-population") else { return }
        let session = URLSession.shared
        
        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in
            
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(GeoDBJSONDecoded.self, from: data)
                        completion(self?.takeDataFromJson(jsonResult: jsonResult) ?? [])
                    } catch let error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
            
        }).resume()
    }
    
    func takeDataFromJson(jsonResult: GeoDBJSONDecoded) -> [Location] {
        var cityNames: [Location] = []
        let datas = jsonResult.data
        for data in datas {
            cityNames.append(Location(city: data.city, longitude: data.longitude, latitude: data.latitude))
        }
        return cityNames
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(cityNameTextField)
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        cityNamesTableView.dataSource = self
        cityNamesTableView.delegate = self
        cityNamesTableView.backgroundColor = .white
        view.addSubview(cityNamesTableView)
        cityNamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        cityNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        
        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextField.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = locationsArray[indexPath.row].city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let text = cell?.textLabel?.text,
              let longitude = locationsArray[indexPath.row].longitude,
              let latitude = locationsArray[indexPath.row].latitude else { return }
        let nextViewController = ShowWeatherViewController(city: text, longitude: longitude, latitude: latitude)
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
