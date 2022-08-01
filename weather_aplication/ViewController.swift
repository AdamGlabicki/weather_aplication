import SnapKit
import UIKit

class ViewController: UIViewController {
    private let kLogoWidth: CGFloat = 250
    private let kLogoHeight: CGFloat = 250
    private let kLeftMargin: CGFloat = 10
    private let kRightMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 20
    private let backgroundView = UIView()
    private let aplicationImage = UIImage(named: "weather_symbol.png")
    private let logoImageView = UIImageView()
    private let aplicationNameLabel = UILabel()
    private let proceedButton = UIButton()
    private let aplicationNameString: String = "MyWeather"
    private let buttonString: String = "Proceed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
    }
    func setupView(){
        view.backgroundColor = .blue
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = aplicationImage
        backgroundView.addSubview(logoImageView)
        
        aplicationNameLabel.text = aplicationNameString
        aplicationNameLabel.textColor = .white
        aplicationNameLabel.textAlignment = .center
        aplicationNameLabel.backgroundColor = .black
        aplicationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(aplicationNameLabel)
        
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.setTitle(buttonString, for: .normal)
        proceedButton.setTitleColor(.red, for: .normal)
        proceedButton.backgroundColor = .yellow
        view.addSubview(proceedButton)
    }
    
    func setupConstraints(){
        backgroundView.snp.makeConstraints{make in
            make.top.equalTo(view.snp.topMargin).offset(kTopMargin)
            make.left.equalTo(view.snp.leftMargin).offset(kLeftMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kRightMargin)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints{make in
            make.width.equalTo(kLogoWidth)
            make.height.equalTo(kLogoHeight)
            make.top.equalTo(backgroundView.snp.topMargin).offset(kTopMargin)
            make.centerX.equalTo(backgroundView.snp.centerX)
            }
        
        aplicationNameLabel.snp.makeConstraints{make in
            make.top.equalTo(logoImageView.snp.bottom).offset(kTopMargin)
            make.left.equalTo(backgroundView.snp.left).offset(kLeftMargin)
            make.right.equalTo(backgroundView.snp.right).offset(-kRightMargin)
        }
        
        proceedButton.snp.makeConstraints{make in
            make.top.equalTo(backgroundView.snp.bottom).offset(kTopMargin).priority(.low)
            make.left.equalTo(view.snp.leftMargin).offset(kLeftMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kRightMargin)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-kBottomMargin)
        }
        
    }
    
}

