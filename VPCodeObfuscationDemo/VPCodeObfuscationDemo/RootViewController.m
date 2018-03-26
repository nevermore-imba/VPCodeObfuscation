//
//  RootViewController.m
//  VPCodeObfuscationDemo
//
//  Created by Axe on 2018/3/21.
//  Copyright © 2018年 Axe. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setVpTitle:@"Vp"];
}

- (IBAction)clickTestButtonAction:(UIButton *)sender forEvent:(UIEvent *)event {
	
}


@end
