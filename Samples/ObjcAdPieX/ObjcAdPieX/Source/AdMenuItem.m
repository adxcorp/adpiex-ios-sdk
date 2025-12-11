#import "AdMenuItem.h"

@implementation AdMenuItem
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    AdMenuItem *item = [[AdMenuItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    return item;
}
@end
