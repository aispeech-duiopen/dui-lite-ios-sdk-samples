
//
//  wakeupEngine.h
//  DUILite_ios_wakeup
//
//  Created by aispeech009 on 08/11/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//

/*!
 
 @header wakeupEngine.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.2.0
 
 */


#import <Foundation/Foundation.h>

/*!
 实现回调函数的协议代理
 */
@protocol wakeupEngineDelete <NSObject>

@required

/*!
 返回唤醒结果
 
 @param data 返回一个json串,key-value
 
    "status":1，表示唤醒成功，0表示失败
 
    "confidence":0.249299, 表示唤醒置信度
 
    "wakeupWord":"ni hao xiao chi", 表示唤醒词
 
    "words":{"ni hao xiao chi":0.24}, 表示唤醒词-阈值（key-value）
 
 */
-(void)onWakeupResult:(NSString*)data;


@optional

/*!
 录音机数据返回

 @param buffer 录音机数据，使用内部录音机起作用
 */
-(void) onWakeupBufferReceived:(NSData*)buffer;


/*!
 返回错误
 
 @param error 错误信息
 */
-(void)onWakeupError:(NSString*)error;


/*!
 引擎启动成功时回调
 */
-(void)onWakeupReadyForSpeech;


@end



/*!
 离线唤醒引擎wakeupEngine接口说明
 */
@interface wakeupEngine : NSObject


/*!
 协议wakeupEngineDelete的对象
 */
@property (nonatomic,assign) id<wakeupEngineDelete>delegate;

/*!
 创建引擎实例

 @return 返回wakeupEngine实例
 */
+(wakeupEngine*)shareInstance;

/*!
 返回引擎实例

 @return 返回wakeupEngine实例
 */
+(wakeupEngine*)getInstance;

/*!
 销毁引擎
 */
+(void)dellocInstance;


/*!
 引擎初始化

 @param delegate 协议代理
 @param configDic 引擎配置信息

         设置唤醒资源名，默认名字为wakeup_aicar-comm.v0.10.1.bin

         设置唤醒资源绝对路径，默认在main bundle中搜索提供的唤醒资源（须要设置唤醒资源名）
         
         设置主唤醒阈值(0到1之间的字符串)，默认为0.24
         
         设置主唤醒词(必填,参数为拼音)，默认为ni hao xiao chi
         
         设置使用第三方录音引擎，默认使用内置录音机,取值为YES，使用第三方录音引擎;取值为NO，不使用第三方录音引擎

 */
-(void)initWakeup:(id)delegate config:(NSMutableDictionary*)configDic;


/*!
 开启唤醒
 */
-(void)startWakeup;


/*!
 关闭唤醒
 */
-(void)stopWakeup;

/*!
 获取主唤醒词
 
 @return 返回一个NSSting
 */
-(NSString*)getWakeupWords NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 设置唤醒词
 
 @param words 唤醒词数组，最多设置127，拼音
 @param threshold 阈值， 默认0.24
 */
-(void)setMinWakeupWords:(NSMutableArray*)words threshold:(NSMutableArray*)threshold NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 获取唤醒词
 
 @return 返回唤醒词数组
 */
-(NSMutableArray*)getMinWakeupWords NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 删除唤醒词
 
 @param words 唤醒词数组
 */
-(void)cancelMinWakeupWords:(NSMutableArray*)words NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 设置唤醒词
 
 @param words 唤醒词数组，最多设置127，拼音
 @param threshold 阈值， 默认0.24
 */
-(void)setWakeupWord:(NSMutableArray*)words threshold:(NSMutableArray*)threshold;

/*!
 获取唤醒词
 
 @return 返回唤醒词数组拼音
 */
-(NSMutableArray*)getWakeupWord;

/*!
 删除唤醒词
 
 @param words 唤醒词数组
 */
-(void)cancelWakeupWord:(NSMutableArray*)words;




-(void)setCustomFeed:(BOOL)customBool;


/*!
 返回是否启用第三方录音引擎
 
 @return 布尔值，YES为使用， NO为没有使用
 */
-(BOOL)getCustomFeed;


/*!
 传入数据,在不使用SDK录音机时调用,须要设置使用第三方引擎

 @param data 音频数据流
 */
-(void)feedData:(NSData*)data;

@end
