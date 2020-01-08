//
//  FavoriteButton.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class FavoriteButton: BooleanButton {
    private var label = UILabel()
    
    private var textForLabel: String {
        return isOn ? "Unfavourite" : "Favourite"
    }
    
    override var isOn: Bool {
        didSet {
            label.text = textForLabel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        makeConstraints()
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
        makeConstraints()
        configureSubViews()
    }
    
    private func addSubviews() {
        addSubview(label)
    }
    
    private func makeConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                           label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                           label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                           label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureSubViews() {
        label.font = .fontFor(textType: .button)
        label.text = textForLabel
        label.textColor = .systemBlue
        label.textAlignment = .center
    }
}
