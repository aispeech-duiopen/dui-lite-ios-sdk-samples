//
//  ViewController.m
//  DUILiteAsrDemol
//
//  Created by aispeech009 on 24/10/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AsrViewController.h"
#import "AICloudASREngine.h"
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"
#import "AICloudASREngineConfig.h"

const static NSString * TAG = @"testAsrEngine";

@interface AsrViewController ()<UITextViewDelegate, AICloudASREngineDelegate,DUILiteDelegate>
{
    AICloudASREngine * asrEngine;
    NSString *asrResult;
    NSString *midAsrResult;
}

//@property UITextField *asrResult;

@property(nonatomic,strong)UILabel *residueLabel;// 输入文本时剩余字数
@property(nonatomic,strong)UILabel *volumeLabel;// 显示音量
@property(nonatomic, strong)NSNumber *count;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation AsrViewController

#pragma mark -按钮事件
- (IBAction)startRecorder:(id)sender {
    asrResult = @"";
    midAsrResult = @"";
    if(asrEngine == nil){
        [self initAsrEngine];
    }
    [asrEngine startAsrEngine];
    
    //第三方录音引擎接口
    if([asrEngine getUseCustomFeed]){
        _count = 0;
        self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerFeedData) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }

}

-(void)timerFeedData{
    if([asrEngine getUseCustomFeed]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test.pcm" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        [asrEngine feedData:data];
    }
    _count = [NSNumber numberWithInteger:(int)([_count integerValue] + 1)];
    NSLog(@"%@, feedData:  %@", TAG, _count);
}
- (IBAction)clearResult:(id)sender {
    self.placeHolderLabel.text = @"";
    self.textView.text = @"";
    [self textViewDidChange:nil];
}

- (IBAction)stopRecorder:(id)sender {
    if([asrEngine getUseCustomFeed]){
        [self.timer invalidate];
        self.timer = nil;
    }
    [asrEngine stopAsrEngine];
}
- (IBAction)cancelAsr:(id)sender {
    [asrEngine cancel];
    self.placeHolderLabel.text = @"";
    self.textView.text = @"";
    [self textViewDidChange:nil];
    if([asrEngine getUseCustomFeed]){
        [self.timer invalidate];
        self.timer = nil;
    }
}



#pragma mark  -初始化
-(void) viewDidDisappear:(BOOL)animated{
    [[AICloudASREngine getInstance] stopAsrEngine];
    if([asrEngine getUseCustomFeed]){
        [self.timer invalidate];
        self.timer = nil;
    }
    if([AICloudASREngine getInstance]){
        [AICloudASREngine dellocInstance];
        asrEngine = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线语音识别";
    
    asrResult = @"";
    midAsrResult = @"";
    [self initAsrEngine];
    //先创建个方便多行输入的textView
    self.textView =[ [UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.09, self.view.frame.size.height*0.4, self.view.frame.size.width*0.82, self.view.frame.size.height*0.25)];
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 1.0;//边宽
    self.textView.layer.cornerRadius = 5.0;//设置圆角
    self.textView.layer.borderColor = UIColor.grayColor.CGColor;
    self.textView.font = [UIFont systemFontOfSize:20];
    
    //再创建个可以放置默认字的lable
    self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,-5,290,60)];
    self.placeHolderLabel.numberOfLines = 0;
    //self.placeHolderLabel.text = @"请输入你的意见最多140字";
    self.placeHolderLabel.text = @"";
    self.placeHolderLabel.backgroundColor =[UIColor clearColor];
    
    //多余的一步不需要的可以不写  计算textview的输入字数 240 140 60 20 +self.view.frame.size.height*0.2
    self.residueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.68,150,60,20)];
    self.residueLabel.backgroundColor = [UIColor clearColor];
    self.residueLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    self.residueLabel.text =[NSString stringWithFormat:@"%@", @"140/140"];
    self.residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    
    
    self.volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1,500,self.view.frame.size.width,20)];
    self.volumeLabel.backgroundColor = [UIColor clearColor];
    self.volumeLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
    self.volumeLabel.text =[NSString stringWithFormat:@"volume:  %f", 0.0];
    self.volumeLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    
    //最后添加上即可
    //[bgView addSubview :self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    [self.textView addSubview:self.residueLabel];
    [self.view addSubview:self.volumeLabel];
    [self.view addSubview:self.textView];
    

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initAsrEngine{
    [self setAudioConfig];
    
    NSString* resBinFile = [[NSBundle mainBundle] pathForResource:@"vad_aihome_v0.6.bin" ofType:nil];
    
    NSMutableDictionary *asrEngineConfigDic = [[NSMutableDictionary alloc] init];
    [asrEngineConfigDic setObject:@"vad_aihome_v0.6.bin" forKey:K_LOCAL_VAD_RES_NAME];
    [asrEngineConfigDic setObject:resBinFile forKey:K_LOCAL_VAD_RES_PATH];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_REAL_BACK];
    [asrEngineConfigDic setObject:[NSNumber numberWithInt:300] forKey:K_PAUSE_TIME];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_CLOUD_VAD_ENABLE];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_LOCAL_VAD_ENABLE];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:YES] forKey:K_COMPRESS];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_USE_CUSTOM_FEED];
    [asrEngineConfigDic setObject:@"aicar" forKey:K_ASR_RES];
    [asrEngineConfigDic setObject:[NSNumber numberWithBool:NO] forKey:K_ENABLECONFIDENCE];

    NSMutableDictionary *authConfigDic = [[NSMutableDictionary alloc] init];
    [authConfigDic setObject:@"1000000120" forKey:K_USER_ID];
    [authConfigDic setObject:@"278581724" forKey:K_PRODUCT_ID];//用户产品ID
    [authConfigDic setObject:@"cbcbd79bd73822515ce5ab6e5cd3dace" forKey:K_API_KEYS];//用户授权key
    [authConfigDic setObject:@"576a24d2fa0f6cdb0642dd84d15aead0" forKey:K_PRODUCT_KEYS];//用户授权productKey
    [authConfigDic setObject:@"a35b4d17663bb1341de98192034a1a21" forKey:K_PRODUCT_SECRET];//用户授权productSecret
    [DUILiteAuth setLogEnabled:YES];
    [DUILiteAuth setAuthConfig:self config:authConfigDic];
    
    asrEngine = [AICloudASREngine sharedInstance];
    [asrEngine asrEngineInit:self config:asrEngineConfigDic];
    //[AICloudASREngine setLogEnabled:YES];
    
}

- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

#pragma mark -用户回调

/**
 引擎初始化成功回调
 */
-(void)onAICloudASREngineInitSuccess{
    NSLog(@"out onAICloudASREngineInitSuccess");
}

/*!
 开始语音识别成功回调
 */
-(void)onAICloudASREngineStartSuccess{
    NSLog(@"out onAICloudASREngineStartSuccess");
}

-(void)onResults:(NSString *)result{
    self.placeHolderLabel.text = @"";
    self.textView.text = result;
    [self textViewDidChange:nil];
    NSLog(@"%@, asrResult: %@", TAG, result);
    
//    if([AICloudASREngine getInstance]){
//        [AICloudASREngine dellocInstance];
//        asrEngine = nil;
//    }
}

-(void)onRealbackResults:(NSString *)result{
    NSLog(@"实时反馈");
}

-(void)onRmsChanged:(NSNumber*)rmsdB{
    NSLog(@"%@, rmsdB: %f", TAG, [rmsdB floatValue]);
    dispatch_async(dispatch_get_main_queue(), ^{
        _volumeLabel.text = [NSString stringWithFormat:@"volume:  %f", [rmsdB floatValue]];
    });
}

-(void)onError:(NSString *)error{
    NSLog(@"%@, error: %@", TAG, error);
}

-(void)onBufferReceived:(NSData *)buffer{
    //NSLog(@"%@, 录音数据返回！", TAG);
}

-(void)onBeginningOfSpeech{
    NSLog(@"%@, 检测到用户开始说话！", TAG);
}

-(void)onEndOfSpeech{
    NSLog(@"%@, 检测到用户结束说话！", TAG);
}

//接下来通过textView的代理方法实现textfield的点击置空默认自负效果

#pragma mark -系统回调
-(void)textViewDidChange:(UITextView*)textView
{
    if([_textView.text length] == 0){
        //self.placeHolderLabel.text = @"请输入你的意见最多140字";
        self.placeHolderLabel.text = @"";
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数   不需要的也可不写
    NSString *nsTextCotent = _textView.text;
    int existTextNum = (int)[nsTextCotent length];
    int remainTextNum = 140 - existTextNum;
    self.residueLabel.text = [NSString stringWithFormat:@"%d/140",remainTextNum];
}
//设置超出最大字数（140字）即不可输入 也是textview的代理方法
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]){ //这里"\n"对应的是键盘的 return 回收键盘之用
        [textView resignFirstResponder];
        return YES;
    }
    if (range.location >= 140){
        return NO;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onAuthResult:(BOOL) message{
    NSLog(@"%@, auth is %@", TAG, message ? @"YES" : @"NO");
}

-(void) onAuthError:(NSString*) error{
    NSLog(@"%@, authError is %@", TAG, error);
}

@end
