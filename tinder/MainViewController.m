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

@end

@implementation MainViewController


- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showSlidingView];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        // Let the user drag the view horizontally
        CGPoint translation = [sender translationInView:self.view];
        self.slidingView.center = CGPointMake(self.slidingView.center.x + translation.x, self.slidingView.center.y);
        self.navBar.center = CGPointMake(self.navBar.center.x + (translation.x / 2), self.navBar.center.y);

        [sender setTranslation:CGPointZero inView:self.view];
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

    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    [self.view addSubview:self.navBar];

    UIView* red = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 40, 40)];
    red.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *pushSettings = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSettingsButton)];
    [red addGestureRecognizer:pushSettings];

    UIView* blue = [[UIView alloc] initWithFrame:CGRectMake(140, 40, 40, 40)];
    blue.backgroundColor = [UIColor blueColor];
    UITapGestureRecognizer *pushMatch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMatchButton)];
    [blue addGestureRecognizer:pushMatch];
    
    UIView* green = [[UIView alloc] initWithFrame:CGRectMake(260, 40, 40, 40)];
    green.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer *pushChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChatButton)];
    [green addGestureRecognizer:pushChat];

    [self.navBar addSubview:red];
    [self.navBar addSubview:blue];
    [self.navBar addSubview:green];
    
    self.navBarEdge = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.navBarEdge.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.navBarEdge];
    
    self.matchViewController = [[MatchScreenViewController alloc] init];
    self.settingsViewController = [[SettingsViewController alloc] init];
    self.chatViewController = [[ChatIndexViewController alloc] init];
    
    [self addChildViewController:self.matchViewController];
    [self addChildViewController:self.settingsViewController];
    [self addChildViewController:self.chatViewController];
    
    [User setUpWithCompletion:^{
        User* user = [User user];
 
        if (user.preferences_set) {
            self.currentViewController = self.matchViewController;
        } else {
            self.currentViewController = self.settingsViewController;
        }
        CGFloat contentY = self.navBar.frame.size.height + self.navBarEdge.frame.size.height;
        self.currentViewController.view.frame = CGRectMake(0,
                                                           contentY,
                                                           self.currentViewController.view.frame.size.width,
                                                           [[UIScreen mainScreen] bounds].size.height - contentY);
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
            scrollNavToX = 120;
            break;
        case MatchView:
            scrollContentToX = 0 - self.matchPositionX;
            scrollNavToX = 0;
            self.currentViewController = self.matchViewController;
            break;
        case ChatView:
            scrollContentToX = 0 - self.chatPositionX;
            scrollNavToX = -120;
            self.currentViewController = self.chatViewController;
            break;
    }

    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.slidingView.frame = CGRectMake(scrollContentToX, self.slidingView.frame.origin.y, self.slidingView.frame.size.width, self.slidingView.frame.size.height);
        self.navBar.frame = CGRectMake(scrollNavToX, 0, self.navBar.frame.size.width, self.navBar.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self.slidingView removeFromSuperview];
        self.currentViewController.view.frame = CGRectMake(0,
                                                   self.navBar.frame.size.height + self.navBarEdge.frame.size.height,
                                                   self.currentViewController.view.frame.size.width,
                                                   self.currentViewController.view.frame.size.height);
        [self.view addSubview:self.currentViewController.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
