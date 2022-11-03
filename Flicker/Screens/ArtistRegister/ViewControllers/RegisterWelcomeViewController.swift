//
//  RegisterWelcomeViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

class RegisterWelcomeViewController: UIViewController {
    
    private let customNavigationBarView = RegisterCustomNavigationView()

    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        $0.text = "작가님 어서오세요!"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .semibold)
        $0.text = "슈글을 통해 사람들의 모습을 담고,\n훌륭한 작가로 성장하세요!"
        $0.setLineSpacing(spacing: 3.0)
    }
    
    private lazy var mainImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "artistReg1.png")
    }
    
    private let dynamicNextButton = UIButton().then {
        $0.setTitle("등록 시작", for: .normal)
        $0.tintColor = .black
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemPink
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configureUI()
        nextButtonTap()
        customBackButtom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func render() {
        view.addSubview(customNavigationBarView)
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(mainImage)
        view.addSubview(dynamicNextButton)
        
        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/16)
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
        }
        
        mainImage.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        dynamicNextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/14)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        dynamicNextButton.layer.cornerRadius = view.bounds.width/18
    }
}

extension RegisterWelcomeViewController {
    private func nextButtonTap() {
        let buttonTapped = UITapGestureRecognizer(target: self, action: #selector(moveNextTapped))
        dynamicNextButton.addGestureRecognizer(buttonTapped)
    }
    
    private func customBackButtom() {
        let backButtonTapped = UITapGestureRecognizer(target: self, action: #selector(moveBackTapped))
        customNavigationBarView.customBackButton.addGestureRecognizer(backButtonTapped)
    }
    
    @objc func moveNextTapped() {
        navigationController?.pushViewController(ArtistRegisterViewController(), animated: false)
    }
    
    @objc func moveBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}
