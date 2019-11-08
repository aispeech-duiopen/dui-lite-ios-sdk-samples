//
//  UITextViewWorkaround.m
//  DUILite_iOS_Demo
//
//  Created by 夏念鑫 on 2019/11/7.
//  Copyright © 2019 speech. All rights reserved.
//

#import "UITextViewWorkaround.h"
#import  <objc/runtime.h>

@implementation UITextViewWorkaround

+ (void)executeWorkaround {
    if (@available(iOS 13.2, *)) {
 
    }
    else {
        const char *className = "_UITextLayoutView";
        Class cls = objc_getClass(className);
        if (cls == nil) {
            cls = objc_allocateClassPair([UIView class], className, 0);
            objc_registerClassPair(cls);
#if DEBUG
            printf("added %s dynamically\n", className);
#endif
        }
    }
}


@end
