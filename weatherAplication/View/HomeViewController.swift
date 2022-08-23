import SnapKit
import UIKit

class HomeViewController: UIViewController {
    private let kLogoWidth: CGFloat = 250
    private let kLogoHeight: CGFloat = 250
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    private let aplicationImage = UIImage(named: "weather_symbol.png")
    private let logoImageView = UIImageView()
    private let aplicationNameLabel = UILabel()
    private let proceedButton = UIButton()
    private let aplicationNameString: String = "MyWeather"
    private let buttonString: String = "Proceed"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()

        proceedButton.addTarget(self, action: #selector(proceedButtonPressed), for: .touchUpInside)
    }

    func setupView() {
        view.backgroundColor = .blue

        logoImageView.image = aplicationImage
        view.addSubview(logoImageView)

        aplicationNameLabel.text = aplicationNameString
        aplicationNameLabel.textColor = .white
        aplicationNameLabel.textAlignment = .center
        aplicationNameLabel.backgroundColor = .black
        view.addSubview(aplicationNameLabel)

        proceedButton.setTitle(buttonString, for: .normal)
        proceedButton.setTitleColor(.red, for: .normal)
        proceedButton.backgroundColor = .yellow
        view.addSubview(proceedButton)
    }

    func setupConstraints() {

        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(kLogoWidth)
            make.height.equalTo(kLogoHeight)
            make.top.equalTo(view.snp.topMargin).offset(kTopMargin)
            make.centerX.equalTo(view.snp.centerX)
        }

        aplicationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(kTopMargin)
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
        }

        proceedButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-kBottomMargin).priority(.required)
        }

    }

}
