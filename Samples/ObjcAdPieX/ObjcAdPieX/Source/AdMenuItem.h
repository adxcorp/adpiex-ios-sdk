#import <Foundation/Foundation.h>

@interface AdMenuItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
@end
