//
//  ASRLocalTest.m
//  ASRLocalTest
//
//  Created by hc on 2018/5/25.
//  Copyright © 2018年 speech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AVFoundation/AVFoundation.h>
#import "DUILiteLocalASREngine.h"
#import "DUILiteLocalASREngineConfig.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"

static NSString * TAG = @"ASRLocalTest";


@interface ASRLocalTest : XCTestCase<DUILiteLocalASREngineDelegate>

@end

@implementation ASRLocalTest

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
    
    [self initLocalASR];
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

//回调接口
//发生错误时回调
-(void)onLocalASRError:(NSString*) error{
    NSLog(@"%@, develop error: %@", TAG, error);
}


//识别结果回调
-(void)onLocalASRResult:(NSString*) result{
    NSLog(@"%@, ASR result: %@", TAG, result);
}


//检测到说话时回调
-(void)onLocalASRSpeakBegin{
    NSLog(@"%@, check people sound begin", TAG);
}


//结束说话时回调
-(void)onLocalASRSpeakEnd{
    NSLog(@"%@, check people sound end", TAG);
}


//音频数据的回调
-(void) onLocalASRAudioData:(NSData*)data{
    NSLog(@"%@, audio data: %@", TAG, data);
}


//音量变化的回调
-(void) onLocalASRRmsChanged:(NSNumber*)rmsdB{
    NSLog(@"%@, sound change: %@", TAG, rmsdB);
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


-(void)initLocalASR{
    NSMutableDictionary *cfg = [[NSMutableDictionary alloc] init];
    NSString * vadResPath = [[NSBundle mainBundle] pathForResource:@"vad_aihome_v0.6.bin" ofType:nil];
    NSString * asrResPath = [[NSBundle mainBundle] pathForResource:@"ebnfr.aicar.1.2.0.bin" ofType:nil];
    NSString * gramResPath = [[NSBundle mainBundle] pathForResource:@"ebnfc.aicar.1.1.0.bin" ofType:nil];
    NSString * gramXbnfPath = [[NSBundle mainBundle] pathForResource:@"gram.xbnf" ofType:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString * gramOutputPath = [path stringByAppendingString:@"/local.net.bin"];

    [cfg setObject:asrResPath forKey:K_ASR_RESBIN_PATH];
    [cfg setObject:vadResPath forKey:K_VAD_RESBIN_PATH];
    [cfg setObject:gramResPath forKey:K_GRAM_RESBIN_PATH];
    [cfg setObject:gramXbnfPath forKey:K_GRAM_EBNF_FILEPATH];
    [cfg setObject:gramOutputPath forKey:K_GRAM_OUTPUT_PATH];
    [[DUILiteLocalASREngine shareInstance] localASREngineInit:self config:cfg];
}

//开始识别，准备说话 引擎启动接口, 停止识别，等待结果 引擎关闭接口
-(void)testStartLocalASREngine{
    [[DUILiteLocalASREngine shareInstance] startLocalASREngine];
    [[DUILiteLocalASREngine shareInstance] stopLocalASREngine];
}

// 取消本次识别 取消本次识别接口
-(void)testCancel{
    [[DUILiteLocalASREngine shareInstance] cancel];
}

//释放识别引擎 引擎释放接口
-(void)testReleaseInstance{
    [DUILiteLocalASREngine releaseInstance];
}

//第三方录音引擎接口 第三方录音机接口
-(void)testFeedData{
    NSData *data = [[NSData alloc] init];
    [[DUILiteLocalASREngine shareInstance] feedData:data];
}

@end
