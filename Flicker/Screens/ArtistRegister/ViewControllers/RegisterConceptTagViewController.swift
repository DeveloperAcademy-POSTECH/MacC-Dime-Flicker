//
//  RegisterConceptTagViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/20.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..) 새로운 뷰...
final class RegisterConceptTagViewController: UIViewController {
    
    // MARK: - custom delegate to send Datas
    weak var delegate: RegisterConceptTagDelegate?
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "컨셉 태그"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "작가님의 대표 컨셉들을 태그로 남겨주세요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "태그를 최대 4개까지 남길 수 있습니다. 검색에 쓰이거나 대표 사진과 함께 쓰입니다.\n띄어쓰기 없이 #을 사용하여 적어주세요!"
    }
    
    private let conceptTagSectionLabel = UILabel().then {
        $0.textColor = .MainTintColor
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .heavy)
        $0.text = "태그"
    }
    
    private let conceptTagExampleSectionLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .semibold)
        $0.text = "예)  #인물사진#영화사진#가족사진#후지필름"
    }
    
    private let conceptTagWarningLabel = UILabel().makeBasicLabel(labelText: "#로 시작하지 않으면 제대로 태그가 생성되지 않을 수 있어요!", textColor: .red.withAlphaComponent(0.5), fontStyle: .footnote, fontWeight: .medium).then {
        $0.numberOfLines = 2
        $0.isHidden = true
    }
    
    // MARK: - textField UI components
    private let conceptTagTextField = UITextField().then {
        $0.text = ""
        $0.clipsToBounds = true
        $0.leftViewMode = .always
        $0.autocorrectionType = .no
        $0.textColor = .textSubBlack
        $0.layer.masksToBounds = true
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.placeholder = "태그 사이를 띄어쓰기 없이 적어주세요!"
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
        guard let checkTextFieldTextEmpty = conceptTagTextField.text else { return }
        if checkTextFieldTextEmpty.isEmpty {
            DispatchQueue.main.async {
                self.conceptTagTextField.becomeFirstResponder()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel, conceptTagSectionLabel, conceptTagExampleSectionLabel, conceptTagTextField, conceptTagWarningLabel)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        conceptTagSectionLabel.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(35)
        }
        
        conceptTagExampleSectionLabel.snp.makeConstraints {
            $0.top.equalTo(conceptTagSectionLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(35)
        }
        
        conceptTagTextField.snp.makeConstraints {
            $0.top.equalTo(conceptTagExampleSectionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(self.view.bounds.height/13)
        }
        
        conceptTagWarningLabel.snp.makeConstraints {
            $0.top.equalTo(conceptTagTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(33)
            $0.trailing.equalToSuperview().inset(33)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground

        conceptTagTextField.delegate = self
        conceptTagTextField.layer.cornerRadius = view.bounds.width/22
    }
}

    // MARK: - textField delegate
extension RegisterConceptTagViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textInput = textField.text else { return true }
        if textInput.count > 1 {
            let firstChar: Character = textInput[textInput.startIndex]
            if firstChar == "#" {
                self.conceptTagWarningLabel.isHidden = true
            } else {
                self.conceptTagWarningLabel.isHidden = false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textInput = textField.text else { return }
        if textInput.count > 1 {
            let firstChar: Character = textInput[textInput.startIndex]
            if firstChar == "#" {
                self.conceptTagWarningLabel.isHidden = true
                print(textInput)
                self.delegate?.conceptTagDescribed(tagLabel: textInput)
            } else {
                self.conceptTagWarningLabel.isHidden = false
                self.delegate?.conceptTagDescribed(tagLabel: "#친절한작가")
            }
        } else {
            self.delegate?.conceptTagDescribed(tagLabel: "#친절한작가")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.dismiss(animated: true)
        return true
    }
}

// MARK: - RegisterConceptTagDelegate custom delegate protocol
protocol RegisterConceptTagDelegate: AnyObject {
    func conceptTagDescribed(tagLabel: String)
}


