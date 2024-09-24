//
//  ResultTableViewCell.swift
//  Map
//
//  Created by Rakesh Kumar on 24/09/24.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier = "ResultTableViewCell"
    
    private var placeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(placeLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeLabel.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: String){
        placeLabel.text = model
    }
}
