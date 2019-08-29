//
//  TTSViewController.m
//  DUILite_ios_CloudTTS_Demo
//
//  Created by hc on 2017/11/9.
//  Copyright © 2017年 speech. All rights reserved.
//

#import "TTSLocalViewController.h"
//包含头文件
#import "AISLocalTTSPlayer.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"
#import <AVFoundation/AVFoundation.h>

static NSString * TAG = @"testLocalTTS";

//需要实现AISTTSPlayerDelegate合成的代理
@interface TTSLocalViewController ()<AISLocalTTSPlayerDelegate>
@property (nonatomic, strong)  AISLocalTTSPlayer* player;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UITextView *refTextView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TTSLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"离线语音合成";
    [self initTTS];
        // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.player releaseTTS];
}


- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}


-(void)initTTS{
    NSMutableDictionary *authConfigDic = [[NSMutableDictionary alloc] init];
    [authConfigDic setObject:@"1000000120" forKey:K_USER_ID];
    [authConfigDic setObject:@"278581724" forKey:K_PRODUCT_ID];//用户产品ID
    [authConfigDic setObject:@"cbcbd79bd73822515ce5ab6e5cd3dace" forKey:K_API_KEYS];//用户授权key
    [authConfigDic setObject:@"576a24d2fa0f6cdb0642dd84d15aead0" forKey:K_PRODUCT_KEYS];//用户授权productKey
    [authConfigDic setObject:@"a35b4d17663bb1341de98192034a1a21" forKey:K_PRODUCT_SECRET];//用户授权productSecret

    [DUILiteAuth setLogEnabled:YES];
    [DUILiteAuth setAuthConfig:self config:authConfigDic];
}

- (IBAction)ttsBtnAction:(id)sender {
    [self setAudioConfig];

    self.tipLabel.text = @"正在合成...";
    //创建语音合成实例（必须有强引用）
    if (!self.player) {
        self.player = [[AISLocalTTSPlayer  alloc] init];
    }
    
    NSString *resBinFile = [[NSBundle mainBundle] pathForResource:@"zhilingf_common_param_ce_local.v2.008.bin" ofType:nil];
    NSString *resDBFile = [[NSBundle mainBundle] pathForResource:@"aitts_dict_idx_common.2.0.4.db" ofType:nil];
    self.player.resBinFile = resBinFile;
    self.player.resDBFile = resDBFile;
    
    //设置协议委托对象
    self.player.delegate = self;
    //self.player.onlyTTS = @"true";
    
    //设置合成参数
    self.player.refText = self.refTextView.text;
    
    self.player.speed = 1.0;
    self.player.volume = 50;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //开始合成
        [self.player startTTS];
    });
}

- (IBAction)pauseBtnAction:(id)sender {
    [self.player pauseTTS];
}


- (IBAction)resumeBtnAction:(id)sender {
    [self.player continueTTS];
}

- (IBAction)stopBtnAction:(id)sender {
    [self.player stopTTS];
}

- (IBAction)clearBtnAction:(id)sender {
    self.refTextView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -AISTTSPlayerDelegate

-(void)onAISLocalTTSInitStart{
    NSLog(@"%@, 本地合成开始", TAG);
}

//合成完成
-(void)onAISLocalTTSInitCompletion{
    NSLog(@"%@, 本地合成完成", TAG);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = @"";
    });

}

-(void)onAISLocalTTSPlayStart{
    NSLog(@"%@, 本地播放开始", TAG);
}

//播放完成
-(void)onAISLocalTTSPlayCompletion{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@, 本地播放完成", TAG);
}

-(void)onAISLocalTTSAudioData:(NSData *)data{
    NSLog(@"%@, 音频数据", TAG);
}

//错误
-(void)onAISLocalTTSError:(NSString *)error{
    NSLog(@"%s error = %@",__FUNCTION__,error);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = @"合成失败";
    });
}

-(void) onAuthResult:(BOOL) message{
    NSLog(@"%@, auth is %@", TAG, message ? @"YES" : @"NO");
}

-(void) onAuthError:(NSString*) error{
    NSLog(@"%@, authError is %@", TAG, error);
}

@end
