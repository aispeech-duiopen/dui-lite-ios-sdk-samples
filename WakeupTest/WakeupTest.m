//
//  WakeupTest.m
//  WakeupTest
//
//  Created by hc on 2018/5/24.
//  Copyright © 2018年 speech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DUILiteAuthConfig.h"
#import "wakeupEngine.h"
#import "wakeupEngineConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "DUILiteAuth.h"

@interface WakeupTest : XCTestCase

@end

@implementation WakeupTest

- (void)setUp {
    [super setUp];
    
    [self setAudioConfig];
    NSMutableDictionary *authConfigDic = [[NSMutableDictionary alloc] init];
    [authConfigDic setObject:@"278569660" forKey:K_PRODUCT_ID];
    [authConfigDic setObject:@"348421f1fa2f60ab8a5c930b5a4d99c0" forKey:K_API_KEYS];
    [authConfigDic setObject:@"auth.beta.dui.ai" forKey:@"auth_server"];
    [authConfigDic setObject:@"1000000120" forKey:K_USER_ID];
    [DUILiteAuth setLogEnabled:YES];
    [DUILiteAuth setAuthConfig:self config:authConfigDic];
    [self initWakeup];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void) onAuthResult:(BOOL) message{
    NSLog(@"auth is %@", message ? @"YES" : @"NO");
}

-(void) onError:(NSString*) error{
    NSLog(@" error is %@", error);
}

-(void) onAuthError:(NSString*) error{
    NSLog(@" authError is %@", error);
}

- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//引擎初始化，设置相关参数
-(void)initWakeup{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString* wakeupResPath = [[NSBundle mainBundle] pathForResource:@"wakeup_aifar_comm_20180104.bin" ofType:nil];
    [dic setObject:[NSNumber numberWithBool:NO] forKey:K_WAKE_CUSTOM];
    [dic setObject:@"wakeup_aifar_comm_20180104.bin" forKey:K_WAKE_RES_NAME];
    [dic setObject:wakeupResPath forKey:K_WAKE_RES_PATH];
    [dic setObject:@"ni hao xiao wang" forKey:K_WAKE_WORDS];
    [dic setObject:@"0.127" forKey:K_WAKE_VALUE];
    [[wakeupEngine shareInstance] initWakeup:self config:dic];
}

//实现回调
-(void)onWakeupResult:(NSString *)data{
    NSLog(@"唤醒结果:  %@", data);
}

-(void)onWakeupBufferReceived:(NSData *)buffer{
    NSLog(@"录音数据:  %@", buffer);
}
-(void)onWakeupReadyForSpeech{
    NSLog(@"engine startDid ");
}

//打开唤醒引擎，可以说话，等待唤醒结果
- (void)testStartWakeup{
    [[wakeupEngine shareInstance] startWakeup];
}

// 关闭唤醒引擎
- (void)testStopWakeup{
    [[wakeupEngine shareInstance] stopWakeup];
}

//获取主唤醒词
- (void)testGetWakeupWords{
    NSString *wakeupWords = [[wakeupEngine shareInstance] getWakeupWords];
    NSLog(@"the wakeup words = %@",wakeupWords);
}

//设置唤醒词
- (void)testSetMinWakeupWords{
    NSMutableArray *arrWords = [[NSMutableArray alloc] init];
    NSMutableArray *arrValues = [[NSMutableArray alloc] init];
    [arrWords addObject:@"ni hao xiao long"];
    [arrWords addObject:@"ni hao xiao shan"];
    [arrValues addObject:@"0.126"];
    [arrValues addObject:@"0.127"];
    [[wakeupEngine shareInstance] setMinWakeupWords:arrWords threshold:arrValues];
}

//获取唤醒词
- (void)testGetMinWakeupWords{
    [[wakeupEngine shareInstance] getMinWakeupWords];
}

//删除唤醒词
- (void)testCancelMinWakeupWords{
    NSMutableArray *arrWords = [[NSMutableArray alloc] init];
    [arrWords addObject:@"ni hao xiao long"];
    [arrWords addObject:@"ni hao xiao shan"];
    [[wakeupEngine shareInstance] cancelMinWakeupWords:arrWords];
}

//第三方录音引擎接口
-(void)testFeedData{
    NSData *data = [[NSData alloc] init];
    [[wakeupEngine shareInstance] feedData:data];
}

//释放引擎接口
-(void)testDellocInstance{
    [wakeupEngine dellocInstance];
}


@end
