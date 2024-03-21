#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HaqqWeb3UtilsRN, NSObject)

RCT_EXTERN_METHOD(
                  generateMnemonic: (NSNumber *) strength
                  resolve: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject
                  )

RCT_EXTERN_METHOD(
                sign: (NSString *) privateKey
                message: (NSString *) message
                resolve: (RCTPromiseResolveBlock) resolve
                rejecter: (RCTPromiseRejectBlock) reject
                )

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
