//
//  RegisterWelcomeViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..) - 1.메인사진바꾸기 2."작가님"만 강조 색깔 넣기
final class RegisterWelcomeViewController: UIViewController {
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()

    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "작가님 어서오세요!"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.text = "슈글을 통해 사람들의 모습을 담고,\n훌륭한 작가로 성장하세요!"
        $0.setLineSpacing(spacing: 3.0)
    }
    
    private lazy var mainImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "artistReg1.png")
    }
    
    // MARK: - action button UI components
    private let dynamicNextButton = UIButton().then {
        $0.setTitle("등록 시작", for: .normal)
        $0.tintColor = .white.withAlphaComponent(0.8)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .mainPink.withAlphaComponent(0.7)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        nextButtonTap()
        customBackButton()
    }
    
    // MARK: - navigation bar hide configurations with life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - layout constraints
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
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(UIScreen.main.bounds.height/2.5)
        }
        
        dynamicNextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        mainImage.layer.cornerRadius = view.bounds.width/20
        dynamicNextButton.layer.cornerRadius = view.bounds.width/18
    }
}

    // MARK: - action functions
extension RegisterWelcomeViewController {
    private func nextButtonTap() {
        let buttonTapped = UITapGestureRecognizer(target: self, action: #selector(moveNextTapped))
        dynamicNextButton.addGestureRecognizer(buttonTapped)
    }
    
    private func customBackButton() {
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
