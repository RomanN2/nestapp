/**
 *  Copyright 2014 Nest Labs Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import "NestConnectViewController.h"
#import "UIColor+Custom.h"
#import "NestAuthManager.h"
#import "NestWebViewAuthController.h"
#import "Texts.h"
#import "DevicesViewController.h"

@interface NestConnectViewController () <NestWebViewAuthControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *nestConnectButton;
@property (nonatomic, strong) NestWebViewAuthController *nestWebViewAuthController;
@property (nonatomic, strong) NSTimer *checkTokenTimer;

@end

@implementation NestConnectViewController
@synthesize nestConnectButton;

#pragma mark View Setup Methods

- (void)setupNestConnectButton
{
    [nestConnectButton setTitleColor:[UIColor nestBlue] forState:UIControlStateNormal];
    [nestConnectButton setTitleColor:[UIColor nestBlueSelected] forState:UIControlStateHighlighted];
    
    [nestConnectButton setTitle:[Texts nestConnectButtonTitle] forState:UIControlStateNormal];
    
    [nestConnectButton.titleLabel setNumberOfLines:4];
    [nestConnectButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [nestConnectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 00.0)];
    
    [nestConnectButton.layer setBorderColor:[UIColor nestBlue].CGColor];
    [nestConnectButton.layer setCornerRadius:8.f];
    [nestConnectButton.layer setBorderWidth:3.f];
    [nestConnectButton.layer setMasksToBounds:YES];
    
    [nestConnectButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:33]];
    [nestConnectButton addTarget:self action:@selector(nestConnectButtonHit:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 * Called when the nest connect button is hit.
 * Presents the web auth URL.
 * @param sender The button that sent the message.
 */
- (void)nestConnectButtonHit:(UIButton *)sender
{
    // First we need to create the authorization_code URL
    NSString *authorizationCodeURL = [[NestAuthManager sharedManager] authorizationURL];
    [self presentWebViewWithURL:authorizationCodeURL];
}


/**
 * Present the web view with the given url.
 * @param url The url you wish to have the web view load.
 */
- (void)presentWebViewWithURL:(NSString *)url
{
    // Present modally the web view controller
    self.nestWebViewAuthController = [[NestWebViewAuthController alloc] initWithURL:url delegate:self];
    [self presentViewController:self.nestWebViewAuthController animated:YES completion:^{}];
}

/**
 * Checks periodically every second after the authorization code is received to
 * see if it has been exchanged for the access token.
 * @param The timer that sent the message.
 */
- (void)checkForAccessToken:(NSTimer *)sender
{
    if ([[NestAuthManager sharedManager] isValidSession]) {
        DevicesViewController *devicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DevicesViewIdentifier"];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:devicesVC] animated:YES];
        [self invalidateTimer];
    }
}

#pragma mark ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNestConnectButton];
    
    // Set the nav bar title
    self.title = [Texts welcome];
    
    [self.nestConnectButton setEnabled:YES];
}

#pragma mark NestWebViewControllerDelegate Methods

/**
 * Called from the NestWebViewControllerDelegate
 * if the user successfully finds the authorization code.
 * @param authorizationCode The authorization code NestAuthManager found.
 */
- (void)foundAuthorizationCode:(NSString *)authorizationCode
{
    [self.nestWebViewAuthController dismissViewControllerAnimated:YES completion:^{}];
    
    // Save the authorization code
    [[NestAuthManager sharedManager] setAuthorizationCode:authorizationCode];
    
    // Check for the access token every second and once we have it leave this page
    [self setupcheckTokenTimer];
    
    // Set the button to disabled
    [self.nestConnectButton setEnabled:NO];
    [self.nestConnectButton setTitle:[Texts loading] forState:UIControlStateNormal];
}

/**
 * Called from the NestWebViewControllerDelegate if the user hits cancel
 * @param sender The button that sent the message.
 */
- (void)cancelButtonHit:(UIButton *)sender
{
    [self.nestWebViewAuthController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Private Methods

/**
 * Invalidate the check token timer
 */
- (void)invalidateTimer
{
    if ([self.checkTokenTimer isValid]) {
        [self.checkTokenTimer invalidate];
        self.checkTokenTimer = nil;
    }
}

/**
 * Setup the checkTokenTimer
 */
- (void)setupcheckTokenTimer
{
    [self invalidateTimer];
    self.checkTokenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkForAccessToken:) userInfo:nil repeats:YES];
}

@end
