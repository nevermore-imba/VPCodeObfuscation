//
//  RootViewController.m
//  VPCodeObfuscationDemo
//
//  Created by Axe on 2018/3/21.
//  Copyright © 2018年 Axe. All rights reserved.
//

#import "RootViewController.h"
#import <VPerson/VPerson.h>
#import "VPViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (strong, nonatomic) VPersonObject *personObject;
@end

@implementation RootViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setVpTitle:@"Vp"];

	NSLog(@"title: %@", _vpTitle);
}

- (IBAction)clickTestButtonAction:(UIButton *)sender forEvent:(UIEvent *)event {
	VPViewController *vc = [[VPViewController alloc] init];
	[self presentViewController:vc animated:YES completion:^{
		VPersonObject *person = [VPersonObject personWithName:@"Axe" age:@323 sex:@"Man"];
		[person introduce];
	}];
}


@end
