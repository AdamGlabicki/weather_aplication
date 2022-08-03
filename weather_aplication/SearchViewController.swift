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
            print("Sugested city name:")
            guard let city = location?.city else {return}
            print(city)
          })
    }
    
    func getCityName(fromCity cityName: String, completion: @escaping (_ result: Location?) -> Void) {
        let queryURL =  URL(string:"https://nominatim.openstreetmap.org/search/?city=" + cityName + "&format=json&addressdetails=1&limit=1")!
        let session = URLSession.shared
        
        session.dataTask(with: queryURL, completionHandler: { data, response, error -> Void in
            
            if (error != nil) {
                completion(nil)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if let array = jsonResult as? Array<Dictionary<String, Any>> {
                            
                            var city: String?
                            if !array.isEmpty {
                                if let address = array[0]["address"] as? Dictionary<String, String> {
                                    city = address["city"]
                                }
                                
                                completion(Location(city: city))
                                
                            } else {
                                completion(nil)
                            }
                        } else {
                            completion(nil)
                        }
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

    func setupView() {
        view.backgroundColor = .white
        
        cityNameTextfield.placeholder = "city name"
        cityNameTextfield.textAlignment = .center
        view.addSubview(cityNameTextfield)
        
        cityNamesTableView.dataSource = self
        cityNamesTableView.delegate  = self
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
      return 1 // to change
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = ""
        return cell
    }
}
