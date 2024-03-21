//
//  String+split.swift
//  HaqqWeb3UtilsRN
//
//  Created by Andrey Makarov on 30.01.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}
