//
//  Wallet.swift
//  HaqqWeb3UtilsRN
//
//  Created by Andrey Makarov on 30.01.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

import CryptoSwift
import secp256k1Swift
import secp256k1Wrapper

enum WalletError: Error {
  case invalid_context;
  case signature_failure;
  case recid
}


public class Wallet {
  var publicKey: [UInt8] {
    get {
      let privateKey = try! secp256k1.Signing.PrivateKey(rawRepresentation: privateKey)
      return [UInt8](privateKey.publicKey.rawRepresentation)
    }
  }
  
  var address: [UInt8] {
      get {
          let pk = Data(publicKey)
          let hash = Digest.sha3(Array(pk.subdata(in: 1..<pk.count)), variant: .keccak256)
          return Array(hash[ 12..<hash.count])
      }
  }
  
  var privateKey: [UInt8]
  
  init(privateKey: [UInt8]) {
    self.privateKey = privateKey
  }
  
  init(privateKey: String) {
    self.privateKey = Array(hex: privateKey);
  }
  
  init(hdkey: HDKey) {
    privateKey = hdkey.privateKey
  }
  
  init(seed: [UInt8]) throws {
    let key = try? HMAC(key: HDKey.masterSecret, variant: .sha512).authenticate(seed)
        
    guard let key = key else {
      throw HDKeyError.seed
    }
    
    self.privateKey = Array(key[0..<32])
  }
  
  public func sign(_ message: [UInt8]) throws -> [UInt8] {
    let hash = Digest.sha3(message, variant: .keccak256)
    
    var pk = privateKey
    guard hash.count == 32 else {
        throw Web3UtilsError.private_key_invalid
    }

    guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)) else {
        throw Web3UtilsError.wallet_context_invalid
    }

    defer {
        secp256k1_context_destroy(ctx)
    }

    let signaturePtr = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
    defer {
        signaturePtr.deallocate()
    }

    guard secp256k1_ecdsa_sign_recoverable(ctx, signaturePtr, hash, pk, nil, nil) == 1 else {
        throw Web3UtilsError.wallet_signature_failed
    }

    let outputPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
    defer {
        outputPtr.deallocate()
    }
    var recid: Int32 = 0
    secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, outputPtr, &recid, signaturePtr)

    let outputWithRecidPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 65)
    defer {
        outputWithRecidPtr.deallocate()
    }
    outputWithRecidPtr.assign(from: outputPtr, count: 64)
    outputWithRecidPtr.advanced(by: 64).pointee = UInt8(recid)

    let signature = Data(bytes: outputWithRecidPtr, count: 65)
        
    return signature.bytes
  }
}
