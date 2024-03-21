//
//  Data+bytes.swift
//  HaqqWeb3UtilsRN
//
//  Created by Andrey Makarov on 30.01.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

extension Data {
    var bytes: [UInt8] {
        var byteArray = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &byteArray, count: self.count)
        return byteArray
    }
}
