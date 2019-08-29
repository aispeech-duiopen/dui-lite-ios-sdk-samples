//
//  ViewController.m
//  DUILite_ios_wakeupDemol
//
//  Created by aispeech009 on 08/11/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//

#import "WakeupViewController.h"
#import "wakeupEngine.h"
#import "wakeupEngineConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "DUILiteAuth.h"
#import "DUILiteAuthConfig.h"

static NSString * TAG = @"testWakeupEngine";

@interface WakeupViewController ()<wakeupEngineDelete, UITextViewDelegate,DUILiteDelegate>

{
    wakeupEngine* engine;
}

//@property (weak, nonatomic) IBOutlet UILabel *wakeupResult;
@property(nonatomic,strong) UILabel *residueLabel;// 输入文本时剩余字数
@property(nonatomic,strong) NSNumber *count;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UITextField *wakeupWordsText;
@property(nonatomic,strong) UITextField *wakeupValueText;

@end



@implementation WakeupViewController

#pragma mark -按钮事件
- (IBAction)startWakeup:(id)sender {
    [engine startWakeup];
    //推荐-->创建方式2
    if([engine getCustomFeed]){
        _count = 0;
        self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerFeedData) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    
    NSLog(@"huangc %@",[engine getWakeupWord]);
}

-(void)timerFeedData{
    if([engine getCustomFeed]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test.pcm" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        [engine feedData:data];
    }
    _count = [NSNumber numberWithInteger:(int)([_count integerValue] + 1)];
    NSLog(@"%@, feedData:  %@", TAG, _count);
}
- (IBAction)clearResult:(id)sender {
//    self.placeHolderLabel.text = @"";
//    //int len = (int)[data length];
//    self.textView.text = @"";
//    [self textViewDidChange:nil];
    [engine setWakeupWord:@[@"ni hao xiao hua", @"ni hao xiao le"] threshold:@[@"0.127", @"0.124"]];
    
}
- (IBAction)deleteWakeup:(id)sender {
    [engine cancelWakeupWord:@[@"ni hao xiao long"]];
}
- (IBAction)getWakeup:(id)sender {
    NSLog(@"wakeup:%@", [engine getWakeupWord]);
}

- (IBAction)stopWakeup:(id)sender {
    
    [engine stopWakeup];
    if([engine getCustomFeed]){
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -初始化
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"离线语音唤醒";
    [self setAudioConfig];
    NSMutableDictionary *authConfigDic = [[NSMutableDictionary alloc] init];
    
    [authConfigDic setObject:@"1000000120" forKey:K_USER_ID];
    [authConfigDic setObject:@"278581724" forKey:K_PRODUCT_ID];//用户产品ID
    [authConfigDic setObject:@"cbcbd79bd73822515ce5ab6e5cd3dace" forKey:K_API_KEYS];//用户授权key
    [authConfigDic setObject:@"576a24d2fa0f6cdb0642dd84d15aead0" forKey:K_PRODUCT_KEYS];//用户授权productKey
    [authConfigDic setObject:@"a35b4d17663bb1341de98192034a1a21" forKey:K_PRODUCT_SECRET];//用户授权productSecret
    
    [DUILiteAuth setLogEnabled:YES];
    [DUILiteAuth setAuthConfig:self config:authConfigDic];
    

    //先创建个方便多行输入的textView
    self.textView =[ [UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.09, self.view.frame.size.height*0.33, self.view.frame.size.width*0.82, self.view.frame.size.height*0.53)];
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
    self.residueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.66,385,60,20)];
    self.residueLabel.backgroundColor = [UIColor clearColor];
    self.residueLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    //self.residueLabel.text =[NSString stringWithFormat:@"%@", @"1000/1000"];
    self.residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    
    
    //最后添加上即可
    //[bgView addSubview :self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    [self.textView addSubview:self.residueLabel];
    [self.view addSubview:self.textView];

    
    [self initWakeup];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initWakeup{
    NSString* wakeupResPath = [[NSBundle mainBundle] pathForResource:@"wakeup_aifar_comm_20180104.bin" ofType:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithBool:NO] forKey:K_WAKE_CUSTOM];
    [dic setObject:@"wakeup_aifar_comm_20180104.bin" forKey:K_WAKE_RES_NAME];
    [dic setObject:wakeupResPath forKey:K_WAKE_RES_PATH];
    engine = [wakeupEngine shareInstance];
    [engine initWakeup:self config:dic];
   
}

-(void)setMinWakeupWords{
    if(![_wakeupWordsText.text isEqualToString:@""] && ![_wakeupValueText.text isEqualToString:@""]){
        [engine setMinWakeupWords:@[self.wakeupWordsText.text] threshold:@[self.wakeupValueText.text]];
    }
}

- (void)setAudioConfig{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}


//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    //[self.timer setFireDate:[NSDate distantFuture]];
    if([wakeupEngine getInstance]){
        [wakeupEngine dellocInstance];
    }
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    //[self.timer setFireDate:[NSDate distantPast]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@, memory leak", TAG);
    // Dispose of any resources that can be recreated.
}

#pragma mark -用户回调

-(void)onWakeupResult:(NSString *)data{
    //_wakeupResult.text = data;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.placeHolderLabel.text = @"";
        //int len = (int)[data length];
        self.textView.text = data;
        [self textViewDidChange:nil];
    });
    NSLog(@"%@, wakeupResult:  %@", TAG, data);
}

-(void)onWakeupBufferReceived:(NSData *)buffer{
    //NSLog(@"%@, onBufferReceived:  %@", TAG, buffer);
}

-(void) onAuthResult:(BOOL) message{
    NSLog(@"%@, auth is %@", TAG, message ? @"YES" : @"NO");
    if (message) {
         [engine setWakeupWord:@[@"ni hao xiao chi", @"ni hao xiao long", @"ni hao xiao ming"] threshold:@[@"0.127", @"0.124", @"0.125"]];
    }
}

-(void) onError:(NSString*) error{
    NSLog(@"%@, error is %@", TAG, error);
}

-(void) onAuthError:(NSString*) error{
    NSLog(@"%@, authError is %@", TAG, error);
}

-(void)onWakeupReadyForSpeech{
    self.placeHolderLabel.text = @"";
    self.textView.text = @"可以说话了";
    [self textViewDidChange:nil];
    NSLog(@"%@, engine startDid ", TAG);
}

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
    int remainTextNum = 1000 - existTextNum;
    //self.residueLabel.text = [NSString stringWithFormat:@"%d/1000",remainTextNum];
}
//设置超出最大字数（140字）即不可输入 也是textview的代理方法
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]){ //这里"\n"对应的是键盘的 return 回收键盘之用
        [textView resignFirstResponder];
        return YES;
    }
    if (range.location >= 1000){
        return NO;
    }else{
        return YES;
    }
}

@end
