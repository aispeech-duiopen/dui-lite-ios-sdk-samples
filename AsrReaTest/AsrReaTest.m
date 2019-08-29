//
//  AsrReaTest.m
//  AsrReaTest
//
//  Created by hc on 2018/5/25.
//  Copyright © 2018年 speech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AVFoundation/AVFoundation.h>
#import "AICloudASREngine.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"
#import "AICloudASREngineConfig.h"

static NSString * TAG = @"AsrReaTest";

@interface AsrReaTest : XCTestCase<AICloudASREngineDelegate>
{
    AICloudASREngine * asrEngine;
}

@end

@implementation AsrReaTest

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
    
    [self initAsrEngine];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

//初始化引擎，设置相关参数
-(void)initAsrEngine{
    NSString* resBinFile = [[NSBundle mainBundle] pathForResource:@"vad_aihome_v0.6.bin" ofType:nil];
    
    NSMutableDictionary *asrEngineConfigDic = [[NSMutableDictionary alloc] init];
    [asrEngineConfigDic setObject:@"vad_aihome_v0.6.bin" forKey:K_LOCAL_VAD_RES_NAME];
    [asrEngineConfigDic setObject:resBinFile forKey:K_LOCAL_VAD_RES_PATH];

    [asrEngineConfigDic setObject:[NSNumber numberWithBool:YES] forKey:K_REAL_BACK];
    //[asrEngineConfigDic setObject:[NSNumber numberWithInt:2800] forKey:K_PAUSE_TIME];//测试第三方录音机
    [asrEngineConfigDic setObject:[NSNumber numberWithInt:300] forKey:K_PAUSE_TIME];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_CLOUD_VAD_ENABLE];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:YES] forKey:K_LOCAL_VAD_ENABLE];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:YES] forKey:K_COMPRESS];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_USE_CUSTOM_FEED];
    asrEngine = [AICloudASREngine sharedInstance];
    [asrEngine asrEngineInit:self config:asrEngineConfigDic];
}

-(void) onResults:(NSString*) result{
    NSLog(@"%@, asrResult: %@", TAG, result);
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

//打开识别引擎，可以说话
-(void)testStartAsrEngine{
    [[AICloudASREngine sharedInstance] startAsrEngine];
}
//关闭识别引擎，等待识别结果
-(void)testStopAsrEngine{
    [[AICloudASREngine sharedInstance] stopAsrEngine];
}
//关闭识别引擎，取消本次识别
-(void)testCancel{
    [[AICloudASREngine sharedInstance] cancel];
}

//第三方录音引擎接口
-(void)testFeedData{
    NSData *data = [[NSData alloc] init];
    [[AICloudASREngine sharedInstance] feedData:data];
}

//释放识别引擎
-(void)testDellocInstance{
    [AICloudASREngine dellocInstance];
}

@end
