//
//  AIEngineBaseOB.h
//  DUILite_ios_LocalWakeupAndVprint
//
//  Created by hc on 2019/4/17.
//  Copyright © 2019 hc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIEngineBaseOB : NSObject
+(instancetype)shareInstance;
+(instancetype)getInstance;
+(void)deallocInstance;

@end

NS_ASSUME_NONNULL_END
