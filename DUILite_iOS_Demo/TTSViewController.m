//
//  TTSViewController.m
//  DUILite_ios_CloudTTS_Demo
//
//  Created by hc on 2017/11/9.
//  Copyright © 2017年 speech. All rights reserved.
//

#import "TTSViewController.h"
//包含头文件
#import "AISTTSPlayer.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"
#import <AVFoundation/AVFoundation.h>

static NSString * TAG = @"testCloudTTS";

//需要实现AISTTSPlayerDelegate合成的代理
@interface TTSViewController ()<AISTTSPlayerDelegate>
@property (nonatomic, strong)  AISTTSPlayer* player;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UITextView *refTextView;
@property (strong, nonatomic) NSMutableArray * array;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TTSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线语音合成";
    self.refTextView.layer.borderWidth = 1.0;//边宽
    self.refTextView.layer.cornerRadius = 5.0;//设置圆角
    self.refTextView.layer.borderColor = UIColor.grayColor.CGColor;
    [self setAudioConfig];
    [self initTTS];
    _array = [[NSMutableArray alloc]  initWithArray:@[@"feyinf", @"xiyaof", @"lzliaf", @"xjingf", @"lucyfa", @"zhilingfa", @"lzliafa", @"lili1f_yubo", @"juyinf_guigushi", @"cyangf", @"xiyaof_laoshi", @"qianranfa", @"aningf", @"yaayif", @"gdgm", @"zhilingf", @"xizhef", @"xijunm", @"xijunma", @"kaolam", @"qiumum", @"tzruim", @"wjianm", @"qianranf", @"linbaf_qingxin", @"linbaf_gaoleng", @"anonyg", @"yukaim_all", @"xiyaof_qingxin", @"hyanif", @"xjingf_gushi", @"zzherf", @"zzhuaf", @"lili1f_diantai", @"hyanifa", @"lanyuf", @"jjingf", @"gqlanf", @"smjief", @"jlshim", @"zxcm", @"kaolaf", @"boy", @"lucyf", @"geyou", @"lili1f_shangwu", @"anonyf"]];
        // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.player stopTTS];
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
    self.tipLabel.text = @"正在合成...";
    //创建语音合成实例（必须有强引用）
    if (!self.player) {
        self.player = [[AISTTSPlayer  alloc] init];
    }
    //设置协议委托对象
    self.player.delegate = self;
    
    //设置合成参数
    self.player.refText = self.refTextView.text;
//     self.player.refText = @"张朝阳在公园散步，吃着Apple sing,唱着歌, 思必驰科技与限公司";
//    self.player.refText = @"<?xml version='1.0' encoding='utf8'?><speak><sentence>张<phoneme py='zhao1'>朝</phoneme>阳在<phoneme py='chao2'>朝</phoneme>阳公园晨练，吃着Apple sing,唱着歌</sentence></speak>";
    self.player.speed = 1.0;
    self.player.volume = 50.0;
    self.player.speaker = @"zhilingf";
//    self.player.ttsType = @"ssml";
//    self.player.cache = [NSNumber numberWithBool:YES];
    
//    self.player.mp3Quality = @"high";
    
    self.player.audioType = @"wav";

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //开始合成
        [self.player startTTS];
    });
}

- (IBAction)pauseBtnAction:(id)sender {
    //暂停
    [self.player pauseTTS];
}


- (IBAction)resumeBtnAction:(id)sender {
    //继续
    [self.player continueTTS];
}

- (IBAction)stopBtnAction:(id)sender {
    //停止
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
//合成完成
-(void)onAISTTSInitCompletion{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@, 云端合成完成", TAG);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = @"";
    });

}

//播放完成
-(void)onAISTTSPlayCompletion{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@, 云端播放完成", TAG);
}

//错误
-(void)onAISTTSError:(NSError *)error{
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
