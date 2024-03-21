//
//  EncrytionError.swift
//  HaqqWeb3UtilsRN
//
//  Created by Andrey Makarov on 06.01.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

public enum Web3UtilsError: Error {
    case mnemonic_invalid;
    case private_key_not_found;
    case private_key_invalid;
    case message_not_found;
    case wallet_context_invalid;
    case wallet_signature_failed;
}
