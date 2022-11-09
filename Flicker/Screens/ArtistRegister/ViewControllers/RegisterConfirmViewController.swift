//
//  RegisterConfirmViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class RegisterConfirmViewController: UIViewController {

    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "축하드려요!"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.text = "작가 등록 승인 받고 작가 활동을 시작해보세요. 승인 여부는 3~4일 정도 소요될 수 있습니다."
        $0.setLineSpacing(spacing: 3.0)
    }
    
    private lazy var mainImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "artistReg1.png")
    }
    
    // MARK: - action button UI components
    private let dynamicNextButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.tintColor = .textSubBlack
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .heavy)
        $0.backgroundColor = .blue.withAlphaComponent(0.7)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        finishRegisterButtonTap()
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
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(mainImage)
        view.addSubview(dynamicNextButton)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(UIScreen.main.bounds.height/8)
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
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
extension RegisterConfirmViewController {
    private func finishRegisterButtonTap() {
        let buttonTapped = UITapGestureRecognizer(target: self, action: #selector(moveNextTapped))
        dynamicNextButton.addGestureRecognizer(buttonTapped)
    }
    
    @objc func moveNextTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
