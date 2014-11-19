//
//  MainViewController.m
//  tinder
//
//  Created by Gaurav Menghani on 11/12/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
#import "MatchScreenViewController.h"
#import "ChatIndexViewController.h"
#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>



@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIView *navBar;
@property (strong, nonatomic) IBOutlet UIView *navBarEdge;

@property (strong, nonatomic) UIView *slidingView;

@property (strong, nonatomic) UIViewController<MainViewControllerDelegate> *settingsViewController;
@property (strong, nonatomic) UIViewController<MainViewControllerDelegate> *matchViewController;
@property (strong, nonatomic) UIViewController<MainViewControllerDelegate> *chatViewController;
@property (strong, nonatomic) UIViewController<MainViewControllerDelegate> *currentViewController;

@property (assign, nonatomic) CGFloat settingsPositionX;
@property (assign, nonatomic) CGFloat matchPositionX;
@property (assign, nonatomic) CGFloat chatPositionX;

@property (strong, nonatomic) UIImageView *logo;

@end

@implementation MainViewController


- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showSlidingView];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        // Let the user drag the view horizontally
        CGPoint translation = [sender translationInView:self.view];
        self.slidingView.center = CGPointMake(self.slidingView.center.x + translation.x, self.slidingView.center.y);
        self.navBar.center = CGPointMake(self.navBar.center.x + (translation.x / 3), self.navBar.center.y);
        [sender setTranslation:CGPointZero inView:self.view];

        CGFloat navDistanceOffCenter = self.view.center.x - self.navBar.center.x;
        CGFloat scaleFactor = navDistanceOffCenter / self.view.frame.size.width * 0.8;

        self.settingsButton.transform = CGAffineTransformMakeScale(1 - scaleFactor, 1 - scaleFactor);
        self.chatButton.transform = CGAffineTransformMakeScale(1 + scaleFactor, 1 + scaleFactor);

        CGFloat matchScaleFactor = fmaxf(1.0, fabsf(navDistanceOffCenter) / 44);
        self.matchButton.transform = CGAffineTransformMakeScale(matchScaleFactor, matchScaleFactor);
        
        if (navDistanceOffCenter == 0) {
            self.logo.alpha = 1;
        } else {
            self.logo.alpha = 1 / fabsf(navDistanceOffCenter / 1.5);
        }

        self.matchButton.frame = CGRectMake(162,
                                            ((self.navBar.frame.size.height - self.matchButton.frame.size.height) / 2) + (fabsf(navDistanceOffCenter) / 13),
                                            self.matchButton.frame.size.width,
                                            self.matchButton.frame.size.height);

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        // Snap to a view, depending on where the frame currently is.
        CGPoint currentLocation = self.slidingView.frame.origin;
        if (currentLocation.x > 0 - ((self.settingsPositionX + self.matchPositionX) / 2)) {
            [self scrollTo:SettingsView];
        } else if (currentLocation.x >= 0 - ((self.matchPositionX + self.chatPositionX) / 2)) {
            [self scrollTo:MatchView];
        } else {
            [self scrollTo:ChatView];
        }
        
    }
}

- (void)showSlidingView {
    int contentHeight = self.view.frame.size.height - (self.navBar.frame.size.height + self.navBarEdge.frame.size.height);

    self.settingsPositionX = 0;
    UIView *settingsView = self.settingsViewController.view;
    settingsView.frame = CGRectMake(self.settingsPositionX, 0, settingsView.frame.size.width, contentHeight);
        
    self.matchPositionX = self.settingsPositionX + settingsView.frame.size.width;
    UIView *matchView = self.matchViewController.view;
    matchView.frame = CGRectMake(self.matchPositionX, 0, matchView.frame.size.width, contentHeight);
        
    self.chatPositionX = self.matchPositionX + matchView.frame.size.width;
    UIView *chatView = self.chatViewController.view;
    chatView.frame = CGRectMake(self.chatPositionX, 0, chatView.frame.size.width, contentHeight);

    if (!self.slidingView) {
        CGFloat currentX;
        switch ([self.currentViewController viewType]) {
            case SettingsView:
                currentX = self.settingsPositionX;
                break;
            case MatchView:
                currentX = 0 - self.matchPositionX;
                break;
            case ChatView:
                currentX = 0 - self.chatPositionX;
                break;
        }

        UIScreen *mainScreen = [UIScreen mainScreen];
        CGRect frame = CGRectMake(currentX,
                                  self.navBar.frame.size.height + self.navBarEdge.frame.size.height,
                                  [mainScreen bounds].size.width,
                                  [mainScreen bounds].size.height - (self.navBar.frame.size.height + self.navBarEdge.frame.size.height));
        self.slidingView = [[UIView alloc] initWithFrame:frame];
    }
    
    [self.currentViewController.view removeFromSuperview];

    [self.slidingView addSubview:settingsView];
    [self.slidingView addSubview:matchView];
    [self.slidingView addSubview:chatView];
    
    [self.view addSubview:self.slidingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60)];
    [self.view addSubview:self.navBar];

    UIImageView *settingsMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gear Mask"]];
    settingsMask.frame = CGRectMake(0, 0, 28, 28);
    self.settingsButton = [[UIView alloc] init];
    self.settingsButton.backgroundColor = [UIColor lightGrayColor];
    self.settingsButton.userInteractionEnabled = YES;
    self.settingsButton.frame = CGRectMake(10,
                                           ((self.navBar.frame.size.height - settingsMask.frame.size.height) / 2) + 10,
                                           settingsMask.frame.size.width,
                                           settingsMask.frame.size.height);
    [self.settingsButton addSubview:settingsMask];
    
    UITapGestureRecognizer *pushSettings = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSettingsButton)];
    [self.settingsButton addGestureRecognizer:pushSettings];

    UIImageView *iconMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13.4, 10)];
    iconMask.image = [UIImage imageNamed:@"Icon"];
    
    self.matchButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13.4, 10)];
    self.matchButton.userInteractionEnabled = YES;
    self.matchButton.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1];
    self.matchButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (iconMask.frame.size.width / 2) + 33,
                            ((self.navBar.frame.size.height - iconMask.frame.size.height) / 2) - 2,
                            iconMask.frame.size.width,
                            iconMask.frame.size.height);
    [self.matchButton addSubview:iconMask];
    
    self.logo = [[UIImageView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (156 / 2),
                                                              (self.navBar.frame.size.height / 2) - (32 / 2) + 10,
                                                              156,
                                                              32)];
    self.logo.image = [UIImage imageNamed:@"Logo"];
                 
    UITapGestureRecognizer *pushMatch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMatchButton)];
    [self.matchButton addGestureRecognizer:pushMatch];

    UIImageView *chatMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chat Mask"]];
    chatMask.frame = CGRectMake(0, 0, 28, 28);

    self.chatButton = [[UIView alloc] init];
    self.chatButton.backgroundColor = [UIColor lightGrayColor];
    self.chatButton.userInteractionEnabled = YES;
    self.chatButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - chatMask.frame.size.width - 10,
                                       ((self.navBar.frame.size.height - chatMask.frame.size.height) / 2) + 10,
                                       chatMask.frame.size.width,
                                       chatMask.frame.size.height);
    [self.chatButton addSubview:chatMask];

    UITapGestureRecognizer *pushChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChatButton)];
    [self.chatButton addGestureRecognizer:pushChat];

    [self.navBar addSubview:self.settingsButton];
    [self.navBar addSubview:self.matchButton];
    [self.navBar addSubview:self.chatButton];
    [self.navBar addSubview:self.logo];
    
    self.navBarEdge = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.navBarEdge.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.navBarEdge];

    CGFloat contentY = self.navBar.frame.size.height + self.navBarEdge.frame.size.height;
    CGRect initialFrame = CGRectMake(0,
                                     contentY,
                                     [[UIScreen mainScreen] bounds].size.width,
                                     [[UIScreen mainScreen] bounds].size.height - contentY);
    
    [User setUpWithCompletion:^{
        User* user = [User user];
 
        self.matchViewController = [[MatchScreenViewController alloc] init];
        self.settingsViewController = [[SettingsViewController alloc] init];
        self.chatViewController = [[ChatIndexViewController alloc] init];
        
        self.matchViewController.view.frame = initialFrame;
        self.settingsViewController.view.frame = initialFrame;
        self.chatViewController.view.frame = initialFrame;
        
        [self addChildViewController:self.matchViewController];
        [self addChildViewController:self.settingsViewController];
        [self addChildViewController:self.chatViewController];
        
        if (user.preferences_set) {
            self.currentViewController = self.matchViewController;
        } else {
            self.currentViewController = self.settingsViewController;
        }
        
        [self.view addSubview:self.currentViewController.view];
        
        [self.matchViewController didMoveToParentViewController:self];
        [self.settingsViewController didMoveToParentViewController:self];
        [self.chatViewController didMoveToParentViewController:self];
    }];
}

- (void)onSettingsButton {
    if ([self.currentViewController viewType] == SettingsView) {
        return;
    }
    [self showSlidingView];
    [self scrollTo:SettingsView];
}

- (void)onMatchButton {
    if ([self.currentViewController viewType] == MatchView) {
        return;
    }
    [self showSlidingView];
    [self scrollTo:MatchView];
}

- (void)onChatButton {
    if ([self.currentViewController viewType] == ChatView) {
        return;
    }
    [self showSlidingView];
    [self scrollTo:ChatView];
}

- (void)scrollTo:(ViewType)view {
    CGFloat scrollContentToX = 0;
    CGFloat scrollNavToX = 0;
    
    switch (view) {
        case SettingsView:
            self.currentViewController = self.settingsViewController;
            scrollNavToX = 130;
            break;
        case MatchView:
            scrollContentToX = 0 - self.matchPositionX;
            scrollNavToX = 0;
            self.currentViewController = self.matchViewController;
            break;
        case ChatView:
            scrollContentToX = 0 - self.chatPositionX;
            scrollNavToX = -130;
            self.currentViewController = self.chatViewController;
            break;
    }

    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        // Finish the content slide animation
        self.slidingView.frame = CGRectMake(scrollContentToX, self.slidingView.frame.origin.y, self.slidingView.frame.size.width, self.slidingView.frame.size.height);

        // Finish the nav slide animation
        self.navBar.frame = CGRectMake(scrollNavToX, 0, self.navBar.frame.size.width, self.navBar.frame.size.height);

        CGFloat navDistanceOffCenter = self.view.center.x - self.navBar.center.x;
        CGFloat scaleFactor = navDistanceOffCenter / self.view.frame.size.width * 0.8;

        // Finish the Settings button scaling animation
        self.settingsButton.transform = CGAffineTransformMakeScale(1 - scaleFactor, 1 - scaleFactor);
        self.chatButton.transform = CGAffineTransformMakeScale(1 + scaleFactor, 1 + scaleFactor);
        
        CGFloat matchScaleFactor = fmaxf(1.0, fabsf(navDistanceOffCenter) / 44);
        self.matchButton.transform = CGAffineTransformMakeScale(matchScaleFactor, matchScaleFactor);
        
        if (navDistanceOffCenter == 0) {
            self.matchButton.center = CGPointMake(([[UIScreen mainScreen] bounds].size.width / 2) - (self.matchButton.frame.size.width / 2) + 40,
                                                  (self.navBar.frame.size.height / 2) - (32 / 2) + 15);
            self.logo.alpha = 1;
            self.chatButton.backgroundColor = [UIColor lightGrayColor];
            self.settingsButton.backgroundColor = [UIColor lightGrayColor];
            self.matchButton.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1];

        } else if (navDistanceOffCenter > 0) {
            self.matchButton.center = CGPointMake(162,
                                                  (self.navBar.frame.size.height / 2) - (32 / 2) + 24);
            self.chatButton.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1];
            self.settingsButton.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1];
            self.matchButton.backgroundColor = [UIColor lightGrayColor];

            self.logo.alpha = 0;
        } else {
            self.chatButton.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1];
            self.settingsButton.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1];
            self.matchButton.backgroundColor = [UIColor lightGrayColor];

            self.matchButton.center = CGPointMake(160,
                                                  (self.navBar.frame.size.height / 2) - (32 / 2) + 24);
            self.logo.alpha = 0;
        }

    } completion:^(BOOL finished) {
        [self.slidingView removeFromSuperview];
        self.currentViewController.view.frame = CGRectMake(0,
                                                   self.navBar.frame.size.height + self.navBarEdge.frame.size.height,
                                                   self.view.frame.size.width,
                                                   self.currentViewController.view.frame.size.height);
        [self.view addSubview:self.currentViewController.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
