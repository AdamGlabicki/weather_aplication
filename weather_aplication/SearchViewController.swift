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
        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
        cityNameTextfield.addTarget(self, action: #selector(loadCityNames), for: .editingChanged)
        
    }
    
    @objc func loadCityNames() {
        guard let cityName = cityNameTextfield.text else {return}
        getCityName(fromCity: cityName, completion: {(location) -> Void in
            guard let results = location else {return}
            if !results.isEmpty {
                var cityArray: [String] = []
                for i in 0...(results.count-1){
                    guard let city = results[i].city else {break}
                    cityArray.append(city)
                    self.cityNameArray = cityArray
                }
            } else {
                return
            }
          })
        cityNamesTableView.reloadData()
    }
    
    func getCityName(fromCity cityName: String, completion: @escaping (_ result: [Location]?) -> Void) {
        guard let queryURL =  URL(string:"http://geodb-free-service.wirefreethought.com/v1/geo/cities?&namePrefix=" + cityName + "&sort=-population") else {completion(nil); return}
        let session = URLSession.shared
        
        session.dataTask(with: queryURL, completionHandler: { [self] data, response, error -> Void in
            
            if (error != nil) {
                completion(nil)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        self.decodeJson(jsonResult: jsonResult, completion: completion)
                    } catch let e {
                        print(e)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
            
        }).resume()
    }
    
    func decodeJson(jsonResult: Any,completion: @escaping (_ result: [Location]?) -> Void) {
        if let dictionary = jsonResult as? Dictionary<String, Any> {
            var cityName: String?
            if let address = dictionary["data"] as? Array<Any> {
                if !address.isEmpty {
                    var locationsArray: [Location] = []
                    for i in 0...(address.count-1) {
                        if let details = address[i] as? Dictionary<String, Any> {
                            if let city = details["city"] as? String {
                                cityName = city
                            } else {
                                break
                            }
                        } else {
                            break
                        }
                        locationsArray.append(Location(city: cityName))
                    }
                    if !locationsArray.isEmpty{
                        completion(locationsArray)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
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
            make.leftMargin.rightMargin.equalToSuperview()
        }
        
        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextfield.snp.bottom).offset(kTopMargin)
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
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
        let mainViewController = HourlyWeatherViewController(city: text)
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
