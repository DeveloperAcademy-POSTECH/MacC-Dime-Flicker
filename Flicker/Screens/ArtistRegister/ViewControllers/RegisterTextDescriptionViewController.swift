//
//  RegisterTextDescriptionViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class RegisterTextDescriptionViewController: UIViewController {

    // MARK: - custom delegate to send Datas
    weak var delegate: RegisterTextInfoDelegate?
    
    // MARK: - view UI components
    static let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "자기 소개"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "미래의 클라이언트에게 어필할 멘트입니다."
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "촬영 경험과 자신의 촬영 스타일을 적어주세요!"
    }
    
    private let descriptionTextView = UITextView().then {
        $0.text = ""
        $0.clipsToBounds = true
        $0.isScrollEnabled = true
        $0.dataDetectorTypes = .all
        $0.textColor = .textSubBlack
        $0.autocorrectionType = .no
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.textContainerInset = UIEdgeInsets(top: 25, left: 10, bottom: 20, right: 10)
        $0.font = .preferredFont(forTextStyle: .callout, weight: .regular)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(RegisterTextDescriptionViewController.mainTitleLabel, subTitleLabel, bodyTitleLabel, descriptionTextView)
        
        RegisterTextDescriptionViewController.mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(RegisterTextDescriptionViewController.mainTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(30)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(UIScreen.main.bounds.height/3)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = view.bounds.width/22
    }
    
    // MARK: - keyboard touch dismiss
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let checkTextViewTextEmpty = descriptionTextView.text else { return }
        if checkTextViewTextEmpty.isEmpty {
            DispatchQueue.main.async {
                self.descriptionTextView.becomeFirstResponder()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

    // MARK: - textView delegate
extension RegisterTextDescriptionViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.textViewDescribed(textView: textView.text)
    }
}

// MARK: - RegisterTextDescription custom delegate protocol
protocol RegisterTextInfoDelegate: AnyObject {
    func textViewDescribed(textView textDescribed: String)
}
