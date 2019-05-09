//
//  ViewController.h
//  DUILiteAsrDemol
//
//  Created by aispeech009 on 24/10/2017.
//  Copyright © 2017 aispeech009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AsrViewController : UIViewController

@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UITextView *textView;

-(void)textViewDidChange:(UITextView*)textView;
-(void)initAsrEngine;

@end

