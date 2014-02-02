//
//  INStartViewController.m
//  Inappropriate
//
//  Created by Amber Conville on 1/31/14.
//  Copyright (c) 2014 Detroit Labs. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "INStartViewController.h"
#import "INCensorVideoViewController.h"

@interface INStartViewController ()

@end

@implementation INStartViewController

- (id)init
{
    self = [super initWithNibName:@"INStartViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)doIt:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }

    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSURL *videoUrl = [info valueForKey:UIImagePickerControllerMediaURL];
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    CMTime duration = asset.duration;
    CMTimeValue value = duration.value;
    CMTimeScale scale = duration.timescale;

    NSMutableArray *mutableTimes = [[NSMutableArray alloc] init];
    CMTimeValue numberOfImages = (value * 30) /scale;
    for (int index = 0; index < numberOfImages; index++) {
        CMTime time = CMTimeMake(index * (scale/30), scale);
        [mutableTimes addObject:[NSValue valueWithCMTime:time]];
    }
    NSArray *times = [NSArray arrayWithArray:mutableTimes];

    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [generator setAppliesPreferredTrackTransform:YES];

    NSMutableArray *mutableCaps = [[NSMutableArray alloc] init];
    [generator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
        [mutableCaps addObject:[UIImage imageWithCGImage:image]];
    }];
    while(mutableCaps.count < times.count) {
        wait(10);
    }
    NSArray *screencaps = [NSArray arrayWithArray:mutableCaps];

    INCensorVideoViewController *controller = [[INCensorVideoViewController alloc] initWithScreencaps:screencaps];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
