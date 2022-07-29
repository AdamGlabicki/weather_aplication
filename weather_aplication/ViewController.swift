import SnapKit
import UIKit

class ViewController: UIViewController {
    private let kLogoWidth: CGFloat = 250
    private let kLogoHeight: CGFloat = 250
    private let kLeftMargin: CGFloat = 10
    private let kRightMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let aplicationImage = UIImage(named: "weather_symbol.png")
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
    }
    func setupView(){
        view.backgroundColor = .blue
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = aplicationImage
        view.addSubview(logoImageView)
    }
    
    func setupConstraints(){
        
        logoImageView.snp.makeConstraints{make in
            make.width.equalTo(kLogoWidth)
            make.height.equalTo(kLogoHeight)
            make.top.equalTo(view.snp.topMargin).offset(kTopMargin)
            make.centerX.equalToSuperview()
            }
        
    }
    
}

