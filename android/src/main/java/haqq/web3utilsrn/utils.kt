package haqq.we3utilsrn

import java.util.*

fun ByteArray.toBase64(): String =
  String(Base64.getEncoder().encode(this))
