//
//  RegisterGearsViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..) keyboard 관련된 액션을 넣어야함
    // 1. 빈 곳을 누르면 키보드가 내려간다. ✅
    // 2. "카메라 TextField" 에서 return 버튼 누르면 그 다음 항목으로 저절로 이어진다.❓
    // 3. "렌즈 TextField" 에서 return 버튼이 키보드를 내린다. ✅
    // 4. 이러나 저러나 모두 layout 을 위로 올린다. ✅
    // 5. 글자 제한 수를 둬야 한다.❓
final class RegisterGearsViewController: UIViewController {
    
    // MARK: - custom delegate to send Datas
    weak var delegate: RegisterGearsDelegate?
    
    // MARK: - view UI components
    // MARK: mainVC 에서 UI layout 변경을 하고자 이렇게 static 으로 선언함
    static let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "장비 정보"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "사용하시는 카메라에 대해 말씀해주세요!"
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
    
    private let cameraBodyExampleSectionLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .semibold)
        $0.text = "예) Sony a7m3, Canon Eos R..."
    }
    
    private let cameraLensSectionLabel = UILabel().then {
        $0.textColor = .MainTintColor
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .heavy)
        $0.text = "렌즈"
    }
    
    private let cameraLensExampleSectionLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .semibold)
        $0.text = "예) Sony 50mm f1.2 GM, Canon RF 24-70mm F2.8..."
    }
    
    // MARK: - textField UI components
    private let cameraBodyTextField = UITextField().then {
        $0.tag = 1
        $0.text = ""
        $0.clipsToBounds = true
        $0.leftViewMode = .always
        $0.autocorrectionType = .no
        $0.textColor = .textSubBlack
        $0.layer.masksToBounds = true
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.placeholder = "카메라 바디의 이름을 적어주세요."
    }
    
    private let cameraLensTextField = UITextField().then {
        $0.tag = 2
        $0.text = ""
        $0.leftViewMode = .always
        $0.autocorrectionType = .no
        $0.textColor = .textSubBlack
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.placeholder = "카메라 렌즈의 이름을 적어주세요."
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
    }
    
    // MARK: - keyboard automatically pop
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let checkTextFieldTextEmpty = cameraBodyTextField.text else { return }
        if checkTextFieldTextEmpty.isEmpty {
            DispatchQueue.main.async {
                self.cameraBodyTextField.becomeFirstResponder()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(RegisterGearsViewController.mainTitleLabel, subTitleLabel, bodyTitleLabel, cameraBodySectionLabel, cameraBodyExampleSectionLabel, cameraBodyTextField, cameraLensSectionLabel, cameraLensExampleSectionLabel, cameraLensTextField)
        
        RegisterGearsViewController.mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(RegisterGearsViewController.mainTitleLabel.snp.bottom).offset(30)
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
    }
    
    // MARK: - view configurations
    private func configUI() {
        cameraBodyTextField.delegate = self
        cameraLensTextField.delegate = self
        
        cameraBodyTextField.layer.cornerRadius = view.bounds.width/22
        cameraLensTextField.layer.cornerRadius = view.bounds.width/22
    }
}


    // MARK: - textField delegate
extension RegisterGearsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            self.delegate?.cameraBodySelected(cameraBody: textField.text ?? "카메라 바디")
        case 2:
            self.delegate?.cameraLensSelected(cameraLens: textField.text ?? "카메라 렌즈")
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

// MARK: - RegisterGears custom delegate protocol
protocol RegisterGearsDelegate: AnyObject {
    func cameraBodySelected(cameraBody bodyName: String)
    func cameraLensSelected(cameraLens lensName: String)
}

