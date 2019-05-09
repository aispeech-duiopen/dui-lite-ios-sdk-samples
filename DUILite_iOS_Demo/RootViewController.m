//
//  ViewController.m
//  DUILite_iOS_Demo
//
//  Created by hc on 2017/11/22.
//  Copyright © 2017年 speech. All rights reserved.
//

#import "RootViewController.h"
#import "TTSViewController.h"
#import "TTSLocalViewController.h"
#import "AsrViewController.h"
#import "WakeupViewController.h"
#import "AsrRealViewController.h"
#import "ASRLocalViewControler.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *rootTableView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    self.rootTableView.delegate = self;
    self.rootTableView.dataSource = self;
    [self.view addSubview:self.rootTableView];
    
    [self.rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    UIView *view = [[UIView alloc] init];
    self.rootTableView.tableFooterView = view;
    
    
#ifndef __OPTIMIZE__
    //这里执行的是debug模式下
    NSLog(@"debug");
#else
    //这里执行的是release模式下
    NSLog(@"release");
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"在线语音识别";
    }
    else if(indexPath.row == 1){
        cell.textLabel.text = @"离线语音唤醒";
    }
    else if(indexPath.row == 2){
        cell.textLabel.text = @"在线语音合成";
    }
    else if(indexPath.row == 3){
        cell.textLabel.text = @"离线语音合成";
    }
    else if(indexPath.row == 4){
        cell.textLabel.text = @"在线语音识别实时反馈";
    }else if(indexPath.row == 5){
        cell.textLabel.text = @"离线语音识别";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (indexPath.row == 0) {
        AsrViewController *viewController = [story instantiateViewControllerWithIdentifier:@"AsrViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(indexPath.row == 1){
        WakeupViewController *viewController = [story instantiateViewControllerWithIdentifier:@"WakeupViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(indexPath.row == 2){
        TTSViewController *viewController = [story instantiateViewControllerWithIdentifier:@"TTSViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(indexPath.row == 3){
        TTSLocalViewController *viewController = [story instantiateViewControllerWithIdentifier:@"TTSLocalViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(indexPath.row == 4){
        AsrRealViewController *viewController = [story instantiateViewControllerWithIdentifier:@"AsrRealViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if(indexPath.row == 5){
        ASRLocalViewControler *viewController = [story instantiateViewControllerWithIdentifier:@"ASRLocalViewControllerID"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


@end
