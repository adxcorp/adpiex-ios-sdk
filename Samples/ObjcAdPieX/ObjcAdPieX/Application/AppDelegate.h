#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)waitForAdPieSDKInitialization:(void (^)(BOOL initialized))completion;

- (void)requestTrackingPermission:(void (^)(BOOL granted))completion;

@end

