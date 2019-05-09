//
//  DUILite_ios_localASR.h
//  DUILite_ios_localASR
//
//  Created by aispeech009 on 2018/5/14.
//  Copyright © 2018 aispeech009. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 实现回调函数的代理协议AISLocalTTSPlayerDelegate
 */
@protocol DUILiteLocalASREngineDelegate <NSObject>

@optional

-(void)onLocalASRError:(NSString*) error;

-(void)onLocalASRResult:(NSString*) result;

-(void)onLocalASRSpeakBegin;

-(void)onLocalASRSpeakEnd;

-(void) onLocalASRAudioData:(NSData*)data;

-(void) onLocalASRRmsChanged:(NSNumber*)rmsdB;

@end


@interface DUILiteLocalASREngine : NSObject

@property(weak, nonatomic) id<DUILiteLocalASREngineDelegate> delegate;

+(DUILiteLocalASREngine *) shareInstance;

+(DUILiteLocalASREngine *) getInstance;

+(void) releaseInstance;

/*!
 引擎初始化
 
 @param deledage 设置代理参数
 @param configDic 引擎配置信息:
 */
-(void)localASREngineInit:(id)deledage config:(NSMutableDictionary*)configDic;

/*!
 开始语音识别,默认启动内置录音机
 */
-(void) startLocalASREngine;

/*!
 停止识别，等待识别结果，使用VAD时，超过VAD右边界则自动停止录音
 */
-(void) stopLocalASREngine;

/*!
 取消本次识别操作
 */
-(void)cancel;

/*!
 传入数据,在不使用SDK录音机时调用,须要设置使用第三方引擎
 
 @param data 音频数据流
 */
-(void)feedData:(NSData*)data;

@end
