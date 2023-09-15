//
//  StringExtension.swift
//  VideoPlayer
//
//  Created by Quynh Nguyen on 15/06/2022.
//

import Foundation
import CryptoKit
import CommonCrypto

extension String {
    func md5() -> String {
        if #available(iOS 13.0, *) {
            guard let d = self.data(using: .utf8) else { return ""}
            let digest = Insecure.MD5.hash(data: d)
            let h = digest.reduce("") { (res: String, element) in
                let hex = String(format: "%02x", element)
                let  t = res + hex
                return t
            }
            return h
            
        } else {
            // Fall back to pre iOS13
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            
            if let d = self.data(using: .utf8) {
                _ = d.withUnsafeBytes { body -> String in
                    CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                    return ""
                }
            }
            let result = (0 ..< length).reduce("") {
                $0 + String(format: "%02x", digest[$1])
            }
            return result
            
        }
    }
}
