# 用代码实现圆形渐变取色面板 ColorPickView
使用 导入#import "ZFColorPickView.h"

         ZFColorPickView *colorView = [[ZFColorPickView alloc]init];
            [self.view addSubview:colorView];
            colorView.currentColorBlock = ^(UIColor * _Nonnull color, CGPoint center) {
                self.view.backgroundColor = color;
            };
            colorView.frame = CGRectMake(100, 100, 200, 200);
