import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private let kTopMargin = 20
    
    private let cityNameTextField: UITextField = {
        let cityNameTextField = UITextField()
        cityNameTextField.placeholder = "city name"
        cityNameTextField.textAlignment = .center
        return cityNameTextField
    }()
    
    private let cityNamesTableView = UITableView()
    private var cityInfosArray: [CityInfo] = []
    private let urlString: String = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    @objc func loadCityNames() {
        guard let cityName = cityNameTextField.text else { return }
        getCityName(fromCity: cityName, completion: { [weak self] (CityInfo) -> Void in
            self?.cityInfosArray = []
            self?.cityInfosArray = CityInfo
            DispatchQueue.main.async {
                self?.cityNamesTableView.reloadData()
            }
          })
    }
    
    func getCityName(fromCity cityName: String, completion: @escaping (_ result: [CityInfo]) -> Void) {
        guard let queryURL =  URL(string: urlString + "&namePrefix=" + cityName + "&sort=-population") else { return }
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
                        let jsonResult = try JSONDecoder().decode(GeoDBDecoded.self, from: data)
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
    
    func takeDataFromJson(jsonResult: GeoDBDecoded) -> [CityInfo] {
        var cityNames: [CityInfo] = []
        cityNames = jsonResult.data.map {$0}
        return cityNames
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(cityNameTextField)
        setupCollectionView()
        cityNameTextField.addTarget(self, action: #selector(loadCityNames), for: .editingChanged)
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
        return cityInfosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = cityInfosArray[indexPath.row].city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityInfoToSend = cityInfosArray[indexPath.row]
        let nextViewController = ShowWeatherViewController(data: cityInfoToSend)
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
