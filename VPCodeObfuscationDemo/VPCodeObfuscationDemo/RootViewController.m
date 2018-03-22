//
//  RootViewController.m
//  VPCodeObfuscationDemo
//
//  Created by Axe on 2018/3/21.
//  Copyright © 2018年 Axe. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self commitMessage:@"Error"];
}


- (void)commitMessage:(NSString *)message {
	[self commitMessage:message eliminate:@{@"id" : @"2u94uw04u0"} traffic:nil];
}

- (void)commitMessage:(NSString *)message0 eliminate:(id)eliminate1 traffic:(void (^)(BOOL val, NSArray *lists))traffic2 {
	NSLog(@"message: %@, eliminate: %@, traffic: %@", message0, eliminate1, traffic2);
}

@end
