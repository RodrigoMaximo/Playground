//
//  Resize+SKSpriteNode.swift
//  Teste
//
//  Created by Rodrigo Maximo on 23/03/19.
//  Copyright © 2019 Rodrigo Maximo. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func resize(with size: CGSize?) {
        guard let size = size else { return }
        let xScale = size.width / self.size.width
        let yScale = size.height / self.size.height
        self.xScale = xScale
        self.yScale = yScale
    }
}
