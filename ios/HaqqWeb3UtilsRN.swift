import Foundation

@objc(HaqqWeb3UtilsRN)
class HaqqWeb3UtilsRN: NSObject {
    @objc
    public func generateMnemonic(_ strength: Optional<NSNumber>, resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
      do {
        let strength =  Int(truncating: strength ?? 16)
        
        let mnemonic = Mnemonic(bytes: Mnemonic.generateEntropy(strength: strength))
        
        if !mnemonic.isValid {
          throw Web3UtilsError.mnemonic_invalid
        }
        
        resolve(mnemonic.mnemonic.joined(separator: " "))
      } catch {
        reject("0", "generateMnemonic \(error)", nil)
      }
    }
    
    @objc
    public func sign(_ privateKey: Optional<String>, message: Optional<String>, resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock)-> Void {
      do {
        guard let privateKey = privateKey else {
          throw Web3UtilsError.private_key_not_found;
        }
        
        guard let message = message else {
          throw Web3UtilsError.message_not_found;
        }

        let wallet = Wallet(privateKey: privateKey)
        
        let sig = try wallet.sign(Array(hex: message))
        
        resolve(Data(sig).toHexString())
      } catch {
        reject("0", "sign \(error)", nil)
      }
    }
}
