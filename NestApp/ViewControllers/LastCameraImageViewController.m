//
//  LastCameraImageViewController.m
//  NestApp
//
//  Created by Roman Nazarkevych on 2/16/16.
//  Copyright © 2016 1. All rights reserved.
//

#import "LastCameraImageViewController.h"
#import "Camera.h"

@interface LastCameraImageViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation LastCameraImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCloseButton];
    [self updateUIValues];
}

- (void)setCamera:(Camera *)value {
    _camera = value;
    [self updateUIValues];
}

- (void)updateUIValues {
    self.title = self.camera.name;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *url = [NSURL URLWithString:self.camera.lastEventImageUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        dispatch_sync(dispatch_get_main_queue(), ^{
           self.imageView.image = image;
       });
   });
}

- (void)addCloseButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
}

- (void)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
