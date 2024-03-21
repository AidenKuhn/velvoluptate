package haqq.we3utilsrn

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import haqq.web3utilsrn.Mnemonic
import haqq.web3utilsrn.Wallet
import haqq.web3utilsrn.decodeHex
import haqq.web3utilsrn.toHex
import java.io.IOException

class HaqqWeb3UtilsRNModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "HaqqWeb3UtilsRN"
  }

  @ReactMethod
  fun generateMnemonic(strength: Int, promise: Promise) {
    try {
      val bytes =  Mnemonic.generateEntropy(strength = strength)
      val mnemonic = Mnemonic(bytes = bytes)

      promise.resolve(mnemonic.mnemonic())

    } catch (e: IOException) {
      promise.reject("0", "generateMnemonic")
    }
  }

  @ReactMethod
  fun sign(privateKey: String, message: String, promise: Promise) {
    try {
      val wallet = Wallet(privateKey = privateKey)

      val msg = if (message.startsWith("0x")) {
        message.substring(2)
      } else {
        message
      }

      val resp = wallet.sign(msg.decodeHex())

      promise.resolve(resp.toHex());
    } catch (_: IOException) {

    } catch (e: java.lang.IllegalArgumentException) {
      promise.reject("0", e)
    }
  }
}
