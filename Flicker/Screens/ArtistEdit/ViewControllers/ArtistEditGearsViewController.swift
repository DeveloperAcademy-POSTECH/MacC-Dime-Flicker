//
//  ArtistEditGearsViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/22.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class ArtistEditGearsViewController: UIViewController {
    
    // MARK: - custom delegate to send Datas
    weak var delegate: EditGearsDelegate?
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()
    
    // MARK: - data Transferred
    var currentBody: String = ""
    var currentLens: String = ""
    private lazy var editedBody: String = currentBody
    private lazy var editedLens: String = currentLens
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .systemTeal
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "장비 수정"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "카메라와 렌즈를 수정할 수 있어요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "메인 카메라 바디와 렌즈를 하나씩 적어주세요."
    }
    
    private let cameraBodySectionLabel = UILabel().then {
        $0.textColor = .MainTintColor
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .heavy)
        $0.text = "카메라"
    }
    
    private lazy var cameraBodyExampleSectionLabel = UILabel().then {
        $0.textColor = .systemGray2.withAlphaComponent(0.9)
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold)
        $0.text = "예)  Sony a7m3, Canon Eos R..."
    }
    
    private let cameraLensSectionLabel = UILabel().then {
        $0.textColor = .MainTintColor
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .heavy)
        $0.text = "렌즈"
    }
    
    private lazy var cameraLensExampleSectionLabel = UILabel().then {
        $0.textColor = .systemGray2.withAlphaComponent(0.9)
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold)
        $0.text = "예)  Sony 50mm f1.2 GM, Canon RF 85mm F2..."
    }
    
    private lazy var completeEditButton = UIButton(type: .system).then {
        $0.isEnabled = false
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemGray2.withAlphaComponent(0.6)
        $0.setTitle("장비 수정 완료", for: .normal)
        $0.clipsToBounds = true
    }
    
    // MARK: - textField UI components
    private lazy var cameraBodyTextField = UITextField().then {
        $0.tag = 1
        $0.text = ""
        $0.clipsToBounds = true
        $0.leftViewMode = .always
        $0.autocorrectionType = .no
        $0.textColor = .textSubBlack
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemTeal.withAlphaComponent(0.1)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.placeholder = "바디를 입력해주세요."
    }
    
    private lazy var cameraLensTextField = UITextField().then {
        $0.tag = 2
        $0.text = ""
        $0.leftViewMode = .always
        $0.autocorrectionType = .no
        $0.textColor = .textSubBlack
        $0.backgroundColor = .systemTeal.withAlphaComponent(0.1)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.placeholder = "렌즈를 입력해주세요."
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
        customBackButton()
        completeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.cameraBodyTextField.text = currentBody
        self.cameraLensTextField.text = currentLens
        self.customNavigationBarView.popImage.isHidden = true
    }
    
    // MARK: - keyboard automatically pop
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(customNavigationBarView, mainTitleLabel, subTitleLabel, bodyTitleLabel, cameraBodySectionLabel, cameraBodyExampleSectionLabel, cameraBodyTextField, cameraLensSectionLabel, cameraLensExampleSectionLabel, cameraLensTextField, completeEditButton)
        
        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/24)
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(30)
        }
        
        cameraBodySectionLabel.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(35)
        }
        
        cameraBodyExampleSectionLabel.snp.makeConstraints {
            $0.top.equalTo(cameraBodySectionLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(35)
        }
        
        cameraBodyTextField.snp.makeConstraints {
            $0.top.equalTo(cameraBodyExampleSectionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(self.view.bounds.height/13)
        }
        
        cameraLensSectionLabel.snp.makeConstraints {
            $0.top.equalTo(cameraBodyTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(35)
        }
        
        cameraLensExampleSectionLabel.snp.makeConstraints {
            $0.top.equalTo(cameraLensSectionLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(35)
        }
        
        cameraLensTextField.snp.makeConstraints {
            $0.top.equalTo(cameraLensExampleSectionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(self.view.bounds.height/13)
        }
        
        completeEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        cameraBodyTextField.delegate = self
        cameraLensTextField.delegate = self
        
        cameraBodyTextField.layer.cornerRadius = view.bounds.width/22
        cameraLensTextField.layer.cornerRadius = view.bounds.width/22
        
        completeEditButton.layer.cornerRadius = view.bounds.width/18
    }
}

    // MARK: - textField delegate
extension ArtistEditGearsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            enableButton()
        case 2:
            enableButton()
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.dismiss(animated: true)
        return true
    }
}

extension ArtistEditGearsViewController {
    private func customBackButton() {
        let backTapped = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        customNavigationBarView.customBackButton.addGestureRecognizer(backTapped)
    }
    
    private func completeButton() {
        let completeTapped = UITapGestureRecognizer(target: self, action: #selector(completeButtonTapped))
        completeEditButton.addGestureRecognizer(completeTapped)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        self.delegate?.cameraBodySelected(cameraBody: cameraBodyTextField.text ?? currentBody)
        self.delegate?.cameraLensSelected(cameraLens: cameraLensTextField.text ?? currentLens)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func enableButton() {
        guard let bodyText = cameraBodyTextField.text, let lensText = cameraLensTextField.text else { return }
        if !bodyText.isEmpty && !lensText.isEmpty {
            completeEditButton.isEnabled = true
            completeEditButton.backgroundColor = .mainPink
        } else {
            completeEditButton.isEnabled = false
            completeEditButton.backgroundColor = .systemGray2.withAlphaComponent(0.6)
        }
    }
}

// MARK: - RegisterGears custom delegate protocol
protocol EditGearsDelegate: AnyObject {
    func cameraBodySelected(cameraBody bodyName: String)
    func cameraLensSelected(cameraLens lensName: String)
}
