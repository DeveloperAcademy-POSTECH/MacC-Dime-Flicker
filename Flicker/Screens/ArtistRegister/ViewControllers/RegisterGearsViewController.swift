//
//  RegisterGearsViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

final class RegisterGearsViewController: UIViewController {
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "장비 정보"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "사용하시는 카메라에 대해 말씀해주세요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "메인으로 쓰는 카메라 바디와 렌즈를\n하나씩만 적어주세요."
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
    // TODO: - keyboard 관련된 액션을 넣어야함
    /// (0. 텍스트 필드를 누르면 search(mapping) 할 수 있는 창이 뜨게 하든지) - 기능 구현 문제
    /// 1. 빈 곳을 누르면 키보드가 내려간다. ⚠️
    /// 2. 텍스트 필드를 누르기 전에 뷰가 넘어오면서 키보드가 올라온다.
    /// 3. 동시에 layout 이 올라간다.
    /// 4. 다음 버튼이 어디로 가야할까?
    ///     4-1. 버튼이 같이 위로 키보드 위로 올라와야 한다.
    ///     4-2. 버튼이 다른 VC 에 있으므로 키보드의 return 버튼이 다음 항목으로 바로 넘어가게끔 한다든가 ⚠️
    ///     4-3. return 버튼이 키보드를 내리게 해준다거나
    /// mini 에서 써본 결과: 렌즈 적는 텍스트필드를 가리지 않는다.
    /// ㄴ> 1. return 버튼을 누르면 키보드를 내려준다 ✅
    ///    2. 이러나 저러나 모두 layout 을 위로 올린다. ⚠️
    private let cameraBodyTextField = UITextField().then {
        $0.text = ""
        $0.tag = 1
        $0.autocorrectionType = .no
        $0.leftViewMode = .always
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .textSubBlack
        $0.placeholder = "카메라 바디의 이름을 적어주세요."
    }
    
    private let cameraLensTextField = UITextField().then {
        $0.text = ""
        $0.tag = 2
        $0.autocorrectionType = .no
        $0.leftViewMode = .always
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.clipsToBounds = true
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .textSubBlack
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
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel, cameraBodySectionLabel, cameraBodyExampleSectionLabel, cameraBodyTextField, cameraLensSectionLabel, cameraLensExampleSectionLabel, cameraLensTextField)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
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
    }
    
    private func configUI() {
        cameraBodyTextField.delegate = self
        cameraLensTextField.delegate = self
        
        cameraBodyTextField.layer.cornerRadius = view.bounds.width/20
        cameraLensTextField.layer.cornerRadius = view.bounds.width/20
    }
}

extension RegisterGearsViewController: UITextFieldDelegate {
    // ShouldBeginEditing ->
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//    }
    
    // DidBeginEditing
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        // 여기에 layout 이 바뀌는 그게 들어가야 하나?
//    }
    
    // ShouldEndEditing
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//
//    }
    
    // DidEndEditing
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//    }
    
    // ShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.dismiss(animated: true)
        return true
    }
}

