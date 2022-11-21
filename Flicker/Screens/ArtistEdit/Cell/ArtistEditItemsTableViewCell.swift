//
//  ArtistEditIemsTableViewCell.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/21.
//

import UIKit
import SnapKit
import Then

class ArtistEditItemsTableViewCell: UITableViewCell {
    
    let cellTextLabel = UILabel().makeBasicLabel(labelText: "a", textColor: .textSubBlack, fontStyle: .title3, fontWeight: .bold)
    
    lazy var cellImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .mainPink
        $0.image = UIImage(systemName: "square")
    }
    
    private let editButton = UIButton(type: .system).then {
        $0.tintColor = .systemIndigo.withAlphaComponent(0.3)
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
    }
    
    private let edittedLabel = UILabel().makeBasicLabel(labelText: "수정됨", textColor: .white, fontStyle: .footnote, fontWeight: .semibold).then {
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.backgroundColor = .systemTeal.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    
    var checkEditted: Bool = false {
        didSet {
            if oldValue == true {
                edittedLabel.isHidden = false
            } else {
                edittedLabel.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .mainPink.withAlphaComponent(0.1)
        render()
        configUI()
    }
    
    private func render() {
        self.addSubviews(cellImage, cellTextLabel, editButton, edittedLabel)
        
        cellImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(self.bounds.height/2)
        }
        
        cellTextLabel.snp.makeConstraints {
            $0.leading.equalTo(cellImage.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(self.bounds.height/2)
        }
        
        edittedLabel.snp.makeConstraints {
            $0.leading.equalTo(cellTextLabel.snp.trailing).offset(11)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(3.5)
            $0.width.equalToSuperview().dividedBy(7)
        }
    }
    
    private func configUI() {
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.edittedLabel.layer.cornerRadius = self.bounds.height/7
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
