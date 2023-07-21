#ifdef __cplusplus
#import "react-native-opencv.h"
#endif

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNOpencvSpec.h"

@interface Opencv : NSObject <NativeOpencvSpec>
#else
#import <React/RCTBridgeModule.h>

@interface Opencv : NSObject <RCTBridgeModule>
#endif

@end
