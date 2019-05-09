//
//  ViewController.h
//  DUILite_ios_wakeupDemol
//
//  Created by aispeech009 on 08/11/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WakeupViewController : UIViewController

@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UITextView *textView;

-(void)textViewDidChange:(UITextView*)textView;

@end

