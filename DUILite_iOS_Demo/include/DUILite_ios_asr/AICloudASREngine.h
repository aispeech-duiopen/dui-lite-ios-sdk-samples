//
//  AICloudASREngine.h
//  DUILite_ios_asr
//
//  Created by aispeech009 on 26/10/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//


/*!
 
 @header AICloudASREngine.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.0
 
 */


#import <Foundation/Foundation.h>

/*!
 实现回调函数的代理协议AICloudASREngineDelegate
 */
@protocol AICloudASREngineDelegate <NSObject>

@required

/*!
 收到结果时执行，请解析

 @param result 返回一个NSString
 */
-(void) onResults:(NSString*) result;


@optional

/*!
 收到实时反馈结果时执行，请解析

 @param result 结果为json串.键(key)eof为1 表示识别结束，识别结果为键Text对应的Value值累加起来;键(key)eof为0 表示键var(key)对应得Value为中间识别结果，可能被改变
 */
-(void) onRealbackResults:(NSString*) result;

/*!
 发生错误时执行

 @param error  错误信息
 */
-(void) onError:(NSString*) error;

/*!
 检测到用户开始说话,本地VAD开启时起作用
 */
-(void) onBeginningOfSpeech;

/*!
 检测到用户停止说话时调用,本地VAD开启时起作用
 */
-(void) onEndOfSpeech;

/*!
 录音机数据返回

 @param buffer 录音机数据，使用内部录音机起作用
 */
-(void) onBufferReceived:(NSData*)buffer;


/*!
 音频音量回调

 @param rmsdB  音量为float类型
 */
-(void) onRmsChanged:(NSNumber*)rmsdB;

@end


/*!
 在线识别引擎AICloudASREngine接口说明
 */
@interface AICloudASREngine : NSObject

/*!
 协议AICloudASREngineDelegate的对象
 */
@property (nonatomic,weak) id<AICloudASREngineDelegate> delegate;

@property (nonatomic,strong) NSString *name;

/*!
 创建引擎实例

 @return AICloudASREngine实例
 */
+(AICloudASREngine*)sharedInstance;

/*!
 返回引擎实例

 @return AICloudASREngine实例
 */
+(AICloudASREngine*)getInstance;

/*!
 销毁引擎
 */
+(void)dellocInstance;

/*!
 引擎初始化

 @param deledage 设置代理参数
 @param configDic 引擎配置信息:
 
        设置压缩音频数据,默认压缩; 值为YSE,压缩; 值为NO,不压缩;
 
        设置是否启用本地vad,默认为YES; 值为YES:使用Vad,值为NO:禁止Vad;
 
        设置VAD名字 默认名字为vad_aihome_v0.6.bin;
 
        设置VAD资源绝对路径，默认在main bundle中搜索提供的vad资源（须要设置VAD资源名;
 
        设置数据实时反馈 默认为NO; 值为YES:使用实时反馈功能,值为NO:不使用实时反馈功能;
 
        设置服务端的vad 默认为NO; 值为YES:开启服务端VAD,值为NO:关闭服务端VAD;
 
        设置VAD右边界时间,单位为ms,默认为300ms;
 
        设置useCustomFeed,默认使用内部录音机,取值NO,使用内部录音机,取值YES,使用第三方录音机;
 
        设置服务器地址，默认为线上环境;
 */
-(void)asrEngineInit:(id)deledage config:(NSMutableDictionary*)configDic;

/*!
 开始语音识别,默认启动内置录音机
 */
-(void) startAsrEngine;

/*!
 停止识别，等待识别结果，使用VAD时，超过VAD右边界则自动停止录音
 */
-(void) stopAsrEngine;


/*!
 取消本次识别操作
 */
-(void)cancel;


/*!
 传入数据,在不使用SDK录音机时调用,须要设置使用第三方引擎
 
 @param data 音频数据流
 */
-(void)feedData:(NSData*)data;

/*!
 返回是否启用第三方录音引擎
 
 @return 布尔值，YES为使用， NO为没有使用
 */
-(BOOL) getUseCustomFeed;

@end
