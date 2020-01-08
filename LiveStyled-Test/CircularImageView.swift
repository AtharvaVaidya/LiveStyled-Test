//
//  CircularImageView.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    private func makeCircular() {
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
    }
    
    override func layoutSubviews() {
        makeCircular()
    }
}
