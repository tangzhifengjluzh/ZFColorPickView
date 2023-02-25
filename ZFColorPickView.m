
#import "ZFColorPickView.h"
#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface ZFColorPickView ()
@property (nonatomic, strong) CAGradientLayer             *gradientLayer;
@property (nonatomic, strong) CAGradientLayer             *gradientLayer2;

@end
@implementation ZFColorPickView

- (UIImageView *)imagecenter
{
    if(_imagecenter == nil){
        _imagecenter = [[UIImageView alloc]initWithImage:kGetImage(@"圆环")];
        //        imagecenter.frame = CGRectMake(frame.size.width/4*3, 70, 20, 20);
        _imagecenter.frame =  CGRectMake(self.frame.size.width/2 - 10, self.frame.size.height/2 - 10, 20, 20);
        [self addSubview:_imagecenter];
    }
    return _imagecenter;
}

-(CAGradientLayer *)gradientLayer
{
    if(_gradientLayer == nil){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = @[(__bridge id)[UIColor magentaColor].CGColor,
                                 (__bridge id)[UIColor blueColor].CGColor,
                                 (__bridge id)[UIColor cyanColor].CGColor,
                                 (__bridge id)[UIColor greenColor].CGColor,
                                 (__bridge id)[UIColor yellowColor].CGColor,
                                 (__bridge id)[UIColor redColor].CGColor,
                                 (__bridge id)[UIColor magentaColor].CGColor];
        gradientLayer.startPoint = CGPointMake(0.5, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 1);

        if (@available(iOS 12.0, *)) {
            gradientLayer.type = kCAGradientLayerConic;
        } else {
            // Fallback on earlier versions
            NSLog(@"error = 不支持ios12以下的设备");
            gradientLayer.type = @"conic";
        }
        gradientLayer.cornerRadius = self.frame.size.width / 2.0;
        // 将渐变颜色面板添加到视图上
//        [self.layer addSublayer:gradientLayer];
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

- (CAGradientLayer *)gradientLayer2
{
    if(_gradientLayer2 == nil){
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        gradientLayer2.frame = self.bounds;
        gradientLayer2.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)ssRGBHexAlpha(0xFFFFFF,0).CGColor];
        gradientLayer2.startPoint = CGPointMake(0.5, 0.5);
        gradientLayer2.endPoint = CGPointMake(1, 1);
        gradientLayer2.type = kCAGradientLayerRadial;
        gradientLayer2.cornerRadius = self.bounds.size.width / 2.0;
//        [self.layer addSublayer:gradientLayer2];
        _gradientLayer2 = gradientLayer2;
    }
    return _gradientLayer2;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 定义圆形渐变颜色面板
    if(_gradientLayer == nil){
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
        [self.layer insertSublayer:self.gradientLayer2 above:self.gradientLayer];
        [self addSubview:self.imagecenter];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    
    if (pow(pointL.x - self.bounds.size.width/2, 2)+pow(pointL.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        self.imagecenter.center = pointL;
        
        UIColor *color = [self colorOfPoint:pointL];
        if (self.currentColorBlock) {
            //            self.currentColorBlock(color,imagecenter.center);
            self.currentColorBlock(color,self.center);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    if (pow(pointL.x - self.bounds.size.width/2, 2)+pow(pointL.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        self.imagecenter.center = pointL;
        UIColor *color = [self colorOfPoint:pointL];
        if (self.currentColorBlock) {
            //            self.currentColorBlock(color,imagecenter.center);
            self.currentColorBlock(color,self.center);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    if (pow(pointL.x - self.bounds.size.width/2, 2)+pow(pointL.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        self.imagecenter.center = pointL;
        UIColor *color = [self colorOfPoint:pointL];
        if (self.currentColorBlock) {
            //            self.currentColorBlock(color,imagecenter.center);
            self.currentColorBlock(color,self.center);
        }
    }
}

- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}
@end
