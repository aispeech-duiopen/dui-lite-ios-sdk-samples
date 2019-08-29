//
//  TTSLocalTest.m
//  TTSLocalTest
//
//  Created by hc on 2018/5/25.
//  Copyright © 2018年 speech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AISLocalTTSPlayer.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"
#import <AVFoundation/AVFoundation.h>


static NSString * TAG = @"TTSLocalTest";

@interface TTSLocalTest : XCTestCase<AISLocalTTSPlayerDelegate>
@property (nonatomic, strong)  AISLocalTTSPlayer* player;

@end

@implementation TTSLocalTest

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

-(void)initTTS{
    //创建语音合成实例（必须有强引用）
    if (!self.player) {
        self.player = [[AISLocalTTSPlayer  alloc] init];
    }

    NSString *resBinFile = [[NSBundle mainBundle] pathForResource:@"zhilingf_common_param_ce_local.v2.008.bin" ofType:nil];
    NSString *resDBFile = [[NSBundle mainBundle] pathForResource:@"aitts_dict_idx_common.2.0.4.db" ofType:nil];
    self.player.resBinFile = resBinFile;
    self.player.resDBFile = resDBFile;
    
    self.player.delegate = self;
    self.player.refText = @"苏州思必驰信息科技有限公司";
    self.player.speed = 1.0;
    self.player.volume = 50;
}
//实现回调：
-(void)onAISLocalTTSInitStart{
    NSLog(@"%@, 本地合成开始", TAG);
}

//合成完成
-(void)onAISLocalTTSInitCompletion{
    NSLog(@"%@, 本地合成完成", TAG);
}


//播放开始
-(void)onAISLocalTTSPlayStart{
    NSLog(@"%@, 本地播放开始", TAG);
}


//播放完成
-(void)onAISLocalTTSPlayCompletion{
    NSLog(@"%@, 本地播放完成", TAG);
}


//音频数据
-(void)onAISLocalTTSAudioData:(NSData *)data{
    NSLog(@"%@, 音频数据", TAG);
}

//错误
-(void)onAISLocalTTSError:(NSString *)error{
    NSLog(@"%s error = %@",__FUNCTION__,error);
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

//释放合成引擎
-(void)testReleaseTTS{
    [self.player releaseTTS];
}

@end
