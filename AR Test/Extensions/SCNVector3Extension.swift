//
//  SCNVector3Extension.swift
//  AR Test
//
//  Created by Michał Warchał on 27.06.2018.
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

extension SCNVector3 {
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}
