//
//  SCNVector3+Transform.swift
//  AR Test
//
//  Created by Michał Warchał on 27.06.2018.
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import ARKit

extension SCNVector3 {
    
    /// Returns position from matrix transform
    ///
    /// - Parameter matrix: Matrix of floats
    static func positionFromTransform(_ matrix: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
    }
}
