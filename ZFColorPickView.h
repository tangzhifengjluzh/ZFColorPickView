
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFColorPickView : UIView
@property (copy, nonatomic) void(^currentColorBlock)(UIColor *color,CGPoint center);
@property (nonatomic, strong)     UIImageView *imagecenter;

@end

NS_ASSUME_NONNULL_END
