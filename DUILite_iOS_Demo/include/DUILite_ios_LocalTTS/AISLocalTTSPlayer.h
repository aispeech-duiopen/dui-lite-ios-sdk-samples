//
//  AISLocalTTSPlayer.h
//  DUILite_ios_LocalTTS
//
//  Created by hc on 2017/11/19.
//  Copyright © 2017年 speech. All rights reserved.
//

/*!
 
 @header AISLocalTTSPlayer.h
 
 @brief This is the interface file .
 
 @author aispeech
 
 @copyright  2017 aispeech. All rights reserved.
 
 @version   1.0.0
 
 */

#import <Foundation/Foundation.h>


/*!
 实现回调函数的代理协议AISLocalTTSPlayerDelegate
 */
@protocol AISLocalTTSPlayerDelegate <NSObject>

@optional

/*!
 合成开始
 */
-(void)onAISLocalTTSInitStart;

/*!
 合成完成时的回调
 */
-(void)onAISLocalTTSInitCompletion;


/*!
 播报开始
 */
-(void)onAISLocalTTSPlayStart;

/*!
 播放完成时的回调
 */
-(void)onAISLocalTTSPlayCompletion;

/*!
 发生错误时的回调
 
 @param error 错误
 */
-(void)onAISLocalTTSError:(NSString *)error;

/*!
 返回音频数据

 @param data 音频数据
 */
-(void)onAISLocalTTSAudioData:(NSData*)data;

@end


/*!
 离线合成引擎接口
 */
@interface AISLocalTTSPlayer : NSObject

/*!
 合成代理对象，
 */
@property (nonatomic,weak) id<AISLocalTTSPlayerDelegate> delegate;


/*!
 只提供合成配置项,取值为字符串@"true"或@"false" 默认为@"false"
 */
@property (nonatomic, weak) NSString * onlyTTS;

/*!
设置离线合成引擎front资源路径
*/
@property (nonatomic, copy) NSString * frontBinFile;

/*!
 设置离线合成引擎发音人资源路径
 */
@property (nonatomic, strong) NSString * resBinFile;


/*!
 设置离线合成引擎TTS资源路径
 */
@property (nonatomic, strong) NSString * resDBFile;

/*!
 设置待合成的文本信息
 */
@property (nonatomic, strong) NSString * refText;


/*!
 设置语速，范围是[0.5,2] 越小越快
 */
@property (nonatomic, assign) float speed;


/*!
 设置音量，范围是[1,100] 越大越响
 */
@property (nonatomic, assign) float volume;

/*!
 启动离线合成引擎，开始合成
 */
- (void)startTTS;


/*!
 关闭离线合成引擎，停止合成
 */
- (void)stopTTS;


/*!
 暂停离线合成引擎，暂停合成播放
 */
- (void)pauseTTS;



/*!
 恢复离线合成引擎，继续合成播放
 */
- (void)continueTTS;


/*!
 释放合成引擎
 */
- (void)releaseTTS;

@end
