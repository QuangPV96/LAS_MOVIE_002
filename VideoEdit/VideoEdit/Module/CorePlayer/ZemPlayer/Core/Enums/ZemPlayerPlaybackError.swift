//
//  ZemPlayerPlaybackError.swift
//
//
//  Created by KAKA on 10/06/22.
//  Copyright © 2022 Di~KAKA. All rights reserved.
//

import Foundation

public enum ZemPlayerPlaybackError {
    case unknown
    case notFound
    case unauthorized
    case authenticationError
    case forbidden
    case unavailable
    case mediaFileError
    case bandwidthExceeded
    case playlistUnchanged
    case decoderMalfunction
    case decoderTemporarilyUnavailable
    case wrongHostIP
    case wrongHostDNS
    case badURL
    case invalidRequest
    case internalServerError
}
