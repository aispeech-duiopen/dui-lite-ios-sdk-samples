//
//  ASRLocalViewControler.m
//  DUILite_iOS_Demo
//
//  Created by aispeech009 on 2018/5/17.
//  Copyright © 2018 speech. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ASRLocalViewControler.h"
#import "DUILiteLocalASREngine.h"
#import "DUILiteLocalASREngineConfig.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"

static NSString * TAG = @"ASRLocalViewControl";

@interface  ASRLocalViewControler() <DUILiteLocalASREngineDelegate>
{
    DUILiteLocalASREngine * localASREngine;
    NSMutableDictionary * cfg;
}
@end

@implementation ASRLocalViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAudioConfig];
    self.title = @"离线语音识别";
    [self initLocalASR];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [DUILiteLocalASREngine releaseInstance];
}

- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}


-(void)initLocalASR{
    NSMutableDictionary *authConfigDic = [[NSMutableDictionary alloc] init];
    [authConfigDic setObject:@"1000000120" forKey:K_USER_ID];
    [authConfigDic setObject:@"278581724" forKey:K_PRODUCT_ID];//用户产品ID
    [authConfigDic setObject:@"cbcbd79bd73822515ce5ab6e5cd3dace" forKey:K_API_KEYS];//用户授权key
    [authConfigDic setObject:@"576a24d2fa0f6cdb0642dd84d15aead0" forKey:K_PRODUCT_KEYS];//用户授权productKey
    [authConfigDic setObject:@"a35b4d17663bb1341de98192034a1a21" forKey:K_PRODUCT_SECRET];//用户授权productSecret
    
    [DUILiteAuth setLogEnabled:YES];
    [DUILiteAuth setAuthConfig:self config:authConfigDic];
    
    self.textASRResult.text = @"";
    
    cfg = [[NSMutableDictionary alloc] init];
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
    localASREngine = [DUILiteLocalASREngine shareInstance];
    [localASREngine localASREngineInit:self config:cfg];
}


- (IBAction)startLocalASREngine:(id)sender {
    self.textASRResult.text = @"可以说话了";
//    [localASREngine startLocalASREngine];
    
    AILocalASRIntent *intent = [[AILocalASRIntent alloc] init];
    intent.useXbnfRec = NO;
    intent.useConf  = NO;
    intent.usePinyin = NO;
    intent.useHoldConf = NO;
    [localASREngine startLocalASREngineWithIntent:intent];
    
    if ([[cfg allKeys] containsObject:K_CUSTOM_FEED_DATA] && [[cfg objectForKey:K_CUSTOM_FEED_DATA] isEqualToString:@"true"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self feedPcm];
        });
    }
}
- (IBAction)stopLocalASREngne:(id)sender {
    [localASREngine stopLocalASREngine];
}
- (IBAction)cancalLocalASREngine:(id)sender {
    [localASREngine cancel];
}

-(void)feedPcm{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nhxp.wav" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    long lenNum = data.length;
    long len = 0;
    while(len< lenNum){
        if (len+3200>lenNum) {
            long plus = lenNum - len;
            NSData *data1 = [data subdataWithRange:NSMakeRange(len, plus)];
            [localASREngine feedData:data1];
        }else{
            NSData *data1 = [data subdataWithRange:NSMakeRange(len, 3200)];
            [localASREngine feedData:data1];
        }
        len = len + 3200;
        sleep(0.1);
    }
}

-(void)onLocalASRError:(NSString*) error{
    NSLog(@"%@, develop error: %@", TAG, error);
}

-(void)onLocalASRResult:(NSString*) result{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textASRResult.text = result;
    });
    NSLog(@"%@, ASR result: %@", TAG, result);
}

-(void)onLocalASRSpeakBegin{
    NSLog(@"%@, check people sound begin", TAG);
}

-(void)onLocalASRSpeakEnd{
    NSLog(@"%@, check people sound end", TAG);
}

-(void) onLocalASRAudioData:(NSData*)data{
    //NSLog(@"%@, audio data: %@", TAG, data);
}

-(void) onLocalASRRmsChanged:(NSNumber*)rmsdB{
    NSLog(@"%@, sound change: %@", TAG, rmsdB);
}

- (IBAction)clearResult:(id)sender {
}
@end
