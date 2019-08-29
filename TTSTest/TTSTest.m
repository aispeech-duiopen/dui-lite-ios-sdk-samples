//
//  TTSTest.m
//  TTSTest
//
//  Created by hc on 2018/5/24.
//  Copyright © 2018年 speech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DUILiteAuthConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "DUILiteAuth.h"
#import "AISTTSPlayer.h"

@interface TTSTest : XCTestCase<AISTTSPlayerDelegate>
@property (nonatomic, strong)  AISTTSPlayer* player;

@end

@implementation TTSTest

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
    
    [self initTTS];
//    [self initWakeup];
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

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

//引擎初始化，设置相关参数
-(void)initTTS{
    if (!self.player) {
        self.player = [[AISTTSPlayer  alloc] init];
    }
    //设置协议委托对象
    self.player.delegate = self;
    //设置合成参数
    self.player.refText = @"苏州思必驰信息科技有限公司";
    self.player.speed = 1.0;
    self.player.volume = 50.0;
    self.player.speaker = @"zhilingf";
}

//实现回调函数
-(void)onAISTTSInitCompletion{
    NSLog(@"语音合成完成");
}

-(void)onAISTTSPlayCompletion{
    NSLog(@"播放完成");
}

-(void)onAISTTSError:(NSError *)error{
    NSLog(@"错误信息: %@",error);
}

//启动合成引擎，等待播放
-(void)testStartTTS{
    [self.player startTTS];
}


//关闭合成引擎，停止合成
-(void)testStopTTS{
    [self.player stopTTS];
}


 //暂停合成引擎，暂停播放
-(void)testPauseTTS{
    [self.player pauseTTS];
}

//恢复合成引擎，继续播放
-(void)testContinueTTS{
    [self.player continueTTS];
}
@end
