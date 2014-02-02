//
//  INCensorVideoViewController.m
//  Inappropriate
//
//  Created by Amber Conville on 1/31/14.
//  Copyright (c) 2014 Detroit Labs. All rights reserved.
//

#import "INCensorVideoViewController.h"
#import "AVFoundation/AVPlayerLayer.h"
#import "AVFoundation/AVPlayer.h"

@interface INCensorVideoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *screencapImageView;
@property(nonatomic, strong) NSArray *screencaps;

@end

@implementation INCensorVideoViewController

- (id)initWithScreencaps:(NSArray *)screencaps
{
    self = [super initWithNibName:@"INCensorVideoViewController" bundle:nil];
    if (self) {
        self.screencaps = screencaps;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.screencapImageView setAnimationImages:self.screencaps];
    [self.screencapImageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
