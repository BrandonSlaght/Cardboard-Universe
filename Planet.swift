//
//  Planet.swift
//  VRBoilerplate
//
//  Created by Admin on 4/20/17.
//  Copyright © 2017 Andrian Budantsov. All rights reserved.
//

import Foundation

class Planet {
         var texture: String?,
               model: String?,
           normalmap: String?,
             ringmap: String?,
ring_transparencymap: String?,
    ring_inner_ratio: Double?,
    ring_outer_ratio: Double?,
          day_length: Double?,
        equator_tilt: Double?

    
        init(texture: String?,
               model: String?,
           normalmap: String?,
             ringmap: String?,
ring_transparencymap: String?,
    ring_inner_ratio: Double?,
    ring_outer_ratio: Double?,
          day_length: Double?,
        equator_tilt: Double?) {
        self.texture = texture
        self.model = model
        self.normalmap = normalmap
        self.ringmap = ringmap
        self.ring_transparencymap = ring_transparencymap
        self.ring_inner_ratio = ring_inner_ratio
        self.ring_outer_ratio = ring_outer_ratio
        self.day_length = day_length
        self.equator_tilt = equator_tilt
    }
}
