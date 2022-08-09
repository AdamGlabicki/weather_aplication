import SnapKit
import UIKit

struct Location {
    public var city: String?
}

class SearchViewController: UIViewController {
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    
    private let cityNameTextfield = UITextField()
    private let cityNamesTableView = UITableView()
    var cityNameArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        cityNameTextfield.addTarget(self, action: #selector(loadCityNames), for: .editingChanged)
        
    }
    
    @objc func loadCityNames() {
        guard let cityName = cityNameTextfield.text else {return}
        getCityName(fromCity: cityName, completion: {(location) -> Void in
            let results = location
            if !results.isEmpty {
                var cityArray: [String] = []
                for result in results{
                    guard let city = result.city else {break}
                    cityArray.append(city)
                }
                self.cityNameArray = cityArray
            } else {
                return
            }
          })
        DispatchQueue.main.async {
             self.cityNamesTableView.reloadData()
         }
    }
    
    func getCityName(fromCity cityName: String, completion: @escaping (_ result: [Location]) -> Void) {
        guard let queryURL =  URL(string:"http://geodb-free-service.wirefreethought.com/v1/geo/cities?&namePrefix=" + cityName + "&sort=-population") else {return}
        let session = URLSession.shared
        
        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in
            
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(GeoDBJSON.self, from: data)
                        completion(self?.decodeJson(jsonResult: jsonResult) ?? [])
                    } catch let e {
                        print(e)
                    }
                } else {}
            } else {}
            
        }).resume()
    }
    
    func decodeJson(jsonResult: GeoDBJSON) -> [Location] {
        var cityNames: [Location] = []
        let datas = jsonResult.data
        for data in datas {
            cityNames.append(Location(city: data.city))
        }
        return cityNames
    }

    func setupView() {
        view.backgroundColor = .white
        
        cityNameTextfield.placeholder = "city name"
        cityNameTextfield.textAlignment = .center
        view.addSubview(cityNameTextfield)
        
        cityNamesTableView.dataSource = self
        cityNamesTableView.delegate = self
        cityNamesTableView.backgroundColor = .white
        view.addSubview(cityNamesTableView)
        cityNamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        cityNameTextfield.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        
        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextfield.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "\(cityNameArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let text = cell?.textLabel?.text else {return}
        let mainViewController = ShowWeatherViewController(city: text)
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
