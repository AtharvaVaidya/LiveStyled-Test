//
//  EventTableViewCell.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    let eventImageView = CircularImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let favoriteButton = FavoriteButton()
    
    private let labelStackView = UIStackView()
    
    static let identifier: String = "EventTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
        makeConstraints()
        configureViews()
    }
    
    private func addSubviews() {
        contentView.addSubview(eventImageView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(favoriteButton)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(dateLabel)
    }
    
    private func makeConstraints() {
        let views = [eventImageView, titleLabel, dateLabel, labelStackView, favoriteButton]
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeAreaGuide = contentView.safeAreaLayoutGuide
        
        let constraints = [eventImageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 15),
                           eventImageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
                           eventImageView.heightAnchor.constraint(equalTo: safeAreaGuide.heightAnchor, multiplier: 0.8),
                           eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor),
                           labelStackView.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8),
                           labelStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
                           labelStackView.heightAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.heightAnchor, multiplier: 0.8),
                           labelStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
                           favoriteButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -15),
                           favoriteButton.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
                           favoriteButton.heightAnchor.constraint(equalTo: safeAreaGuide.heightAnchor, multiplier: 0.8)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureViews() {
        eventImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = .fontFor(textType: .label)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        
        dateLabel.font = .fontFor(textType: .secondaryLabel)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .left
        
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillProportionally
        labelStackView.spacing = 5
        
        selectionStyle = .none
    }
}
