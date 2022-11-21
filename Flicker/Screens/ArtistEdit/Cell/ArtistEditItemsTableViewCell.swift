//
//  ArtistEditIemsTableViewCell.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/21.
//

import UIKit

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .mainPink.withAlphaComponent(0.1)
        render()
        configUI()
    }
    
    private func render() {
        self.addSubviews(cellImage, cellTextLabel, editButton)
        
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
    }
    
    private func configUI() {
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
