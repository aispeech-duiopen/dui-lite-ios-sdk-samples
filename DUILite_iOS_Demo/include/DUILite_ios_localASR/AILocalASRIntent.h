//
//  AILocalASRIntent.h
//  DUILite_ios_localASR
//
//  Created by hc on 2019/7/29.
//  Copyright © 2019 aispeech009. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AILocalASRIntent : NSObject

@property (nonatomic, assign) BOOL useXbnfRec; // 默认不输出扩展语法结果
@property (nonatomic, assign) BOOL useConf; // 默认开启置信度
@property (nonatomic, assign) BOOL usePinyin; // 默认关闭拼音
@property (nonatomic, assign) BOOL useHoldConf; //默认开启ngram置信度

- (NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
