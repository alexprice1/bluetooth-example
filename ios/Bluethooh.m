#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(Bluetooth, NSObject)

RCT_EXTERN_METHOD(sendMessage:(NSString *)message)

RCT_EXTERN_METHOD(reconnect)

@end