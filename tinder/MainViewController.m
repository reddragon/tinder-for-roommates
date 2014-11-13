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

typedef NS_ENUM(NSInteger, AppView) {
    Settings,
    Match,
    Chat
};

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBar;

@property (strong, nonatomic) UIView *slidingView;

@property (strong, nonatomic) UIViewController *settingsViewController;
@property (strong, nonatomic) UIViewController *matchViewController;
@property (strong, nonatomic) UIViewController *chatViewController;
@property (strong, nonatomic) UIViewController *currentViewController;

@property (assign, nonatomic) CGFloat settingsPositionX;
@property (assign, nonatomic) CGFloat matchPositionX;
@property (assign, nonatomic) CGFloat chatPositionX;

@end

@implementation MainViewController


- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {

        [self.currentViewController.view removeFromSuperview];
        [self showSlidingView];
        [self.view addSubview:self.slidingView];

    } else if (sender.state == UIGestureRecognizerStateChanged) {

        // Let the user drag the view horizontally
        CGPoint translation = [sender translationInView:self.view];
        self.slidingView.center = CGPointMake(self.slidingView.center.x + translation.x, self.slidingView.center.y);
        [sender setTranslation:CGPointZero inView:self.view];

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // Snap to a view, depending on where the frame currently is.
        CGPoint currentLocation = self.slidingView.frame.origin;
        if (currentLocation.x > 0 - ((self.settingsPositionX + self.matchPositionX) / 2)) {
            [self scrollTo:Settings];
        } else if (currentLocation.x >= 0 - ((self.matchPositionX + self.chatPositionX) / 2)) {
            [self scrollTo:Match];
        } else {
            [self scrollTo:Chat];
        }
        
    }
}

- (void)showSlidingView {
    if (!self.slidingView) {
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGRect frame = CGRectMake(0,
                                  self.navBar.frame.size.height,
                                  [mainScreen bounds].size.width,
                                  [mainScreen bounds].size.height - self.navBar.frame.size.height);
        _slidingView = [[UIView alloc] initWithFrame:frame];
    }

    int contentHeight = self.view.frame.size.height - self.navBar.frame.size.height;

    self.settingsPositionX = 0;
    UIView *preferencesView = self.settingsViewController.view;
    preferencesView.frame = CGRectMake(self.settingsPositionX, 0, preferencesView.frame.size.width, contentHeight);
        
    self.matchPositionX = self.settingsPositionX + preferencesView.frame.size.width;
    UIView *matchView = self.matchViewController.view;
    matchView.frame = CGRectMake(self.matchPositionX, 0, matchView.frame.size.width, contentHeight);
        
    self.chatPositionX = self.matchPositionX + matchView.frame.size.width;
    UIView *chatView = self.chatViewController.view;
    chatView.frame = CGRectMake(self.chatPositionX, 0, chatView.frame.size.width, contentHeight);
    
    [self.slidingView addSubview:preferencesView];
    [self.slidingView addSubview:matchView];
    [self.slidingView addSubview:chatView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _matchViewController = [[MatchScreenViewController alloc] init];
    _settingsViewController = [[SettingsViewController alloc] init];
    _chatViewController = [[ChatIndexViewController alloc] init];

    
    [User setUpWithCompletion:^{
        User* user = [User user];
/*
        PFQuery *query = [PFUser query];
        [query getObjectInBackgroundWithId:@"3KKorDzix7" block:^(PFObject *object, NSError *error) {
            PFObject *her = object;
            NSLog(@"%@", her);
            [query getObjectInBackgroundWithId:@"upQbSlLbYp" block:^(PFObject *object, NSError *error) {
                PFObject *me = object;
                PFObject *match = [PFObject objectWithClassName:@"matches"];
                match[@"to"] = her;
                match[@"from"] = me;

                PFObject *matchTwo = [PFObject objectWithClassName:@"matches"];
                matchTwo[@"to"] = me;
                matchTwo[@"from"] = her;
                
                [match saveInBackground];
                [matchTwo saveInBackground];
            }];
        }];
  */      
        if (user.preferences_set) {
            self.currentViewController = self.matchViewController;
        } else {
            self.currentViewController = self.settingsViewController;
        }
        self.currentViewController.view.frame = CGRectMake(0,
                                                            self.navBar.frame.size.height,
                                                            self.currentViewController.view.frame.size.width,
                                                            self.currentViewController.view.frame.size.height);
        [self.view addSubview:self.currentViewController.view];
    }];
}

- (void)scrollTo:(AppView)view {
    UIViewController *nextViewController;

    CGFloat scrollToX = 0;
    switch (view) {
        case Settings:
            nextViewController = self.settingsViewController;
            break;
        case Match:
            scrollToX = 0 - self.matchPositionX;
            nextViewController = self.matchViewController;
            break;
        case Chat:
            scrollToX = 0 - self.chatPositionX;
            nextViewController = self.chatViewController;
            break;
    }

    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.slidingView.frame = CGRectMake(scrollToX, self.slidingView.frame.origin.y, self.slidingView.frame.size.width, self.slidingView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.slidingView removeFromSuperview];
        nextViewController.view.frame = CGRectMake(0,
                                         self.navBar.frame.size.height,
                                         nextViewController.view.frame.size.width,
                                         nextViewController.view.frame.size.height);
        [self.view addSubview:nextViewController.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
