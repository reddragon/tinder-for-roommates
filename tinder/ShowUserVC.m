//
//  ShowUserVC.m
//  tinder
//
//  Created by Gaurav Menghani on 11/15/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ShowUserVC.h"
#import "User.h"
#import "ShowMatchVC.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface ShowUserVC ()

@property (weak, nonatomic) IBOutlet UIImageView *passImage;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;

@property (strong, nonatomic) MatchUserView *matchUserView;
@property (strong, nonatomic) NSMutableArray* usersToShow;

@end

@implementation ShowUserVC

- (IBAction)passTouchDown {
    [UIView animateWithDuration:0.4 animations:^{
        self.passImage.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }];
}

- (IBAction)passTouchUpInside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.passImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [[self.matchUserView topCard] nextCardWithLike:NO];
    }];
}

- (IBAction)passTouchUpOutside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.passImage.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)passTouchCancel {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.passImage.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)likeTouchDown:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.likeImage.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }];
}

- (IBAction)likeTouchUpInside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.likeImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [[self.matchUserView topCard] nextCardWithLike:YES];
    }];
}

- (IBAction)likeTouchUpOutside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.likeImage.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)likeTouchCancel {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.likeImage.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)infoTouchDown {
    [UIView animateWithDuration:0.4 animations:^{
        self.infoImage.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }];
}

- (IBAction)infoTouchUpInside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.infoImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // Show Profile
    }];
}
- (IBAction)infoTouchUpOutside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.infoImage.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)infoTouchCancel {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.infoImage.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usersToShow = [[NSMutableArray alloc] init];
    CGFloat matchUserViewWidth = [[UIScreen mainScreen] bounds].size.width - 20;
    self.matchUserView = [[MatchUserView alloc] initWithFrame:CGRectMake(10,
                                                                         20,
                                                                         matchUserViewWidth,
                                                                         matchUserViewWidth * 1.2)];
    self.matchUserView.delegate = self;

    [self.view addSubview:self.matchUserView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self prepareView];
}

- (void)addNewUsersToShow:(NSMutableArray*) users {
    
    // TODO Handle the case when
    // we are in the middle of browsing
    // and the users are found and
    // added.
    [self.usersToShow addObjectsFromArray:users];
    [self prepareView];
}

- (void)prepareView {
    if ([self.usersToShow count] > 0) {
        self.matchUserView.users = self.usersToShow;
        self.matchUserView.hidden = NO;
    } else {
        self.matchUserView.hidden = YES;
    }
    // [self.nameLabel setText:[NSString stringWithFormat:@"%@, %ld", userToShow.name, userToShow.age]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeCurrentUser {
    [self.usersToShow removeLastObject];
    if ([self.usersToShow count] == 0) {
        NSLog(@"Ran out of profiles to show!");
        if (self.delegate != nil) {
            [self.delegate onDoneWithUserList];
        }
    }
}

- (User*)currentUserForMatching {
    return [self.usersToShow lastObject];
}

- (void)registerLikeOrPass:(BOOL)like  forUser:(User *)user {
    PFObject* match = [[PFObject alloc] initWithClassName:@"matches"];
    match[@"from"] = [[User user] pfUser];
    match[@"from_fbid"] = [[User user] fbid];
    
    match[@"to"] = user.pfUser;
    match[@"to_fbid"] = user.fbid;
    match[@"matched"] = @(like);
    [match saveInBackground];
    
    [self removeCurrentUser];
    
    // if (true) {
    if (like && [user likesUs]) {
        ShowMatchVC* matchVC = [[ShowMatchVC alloc] initWithMatchingUser:user];
        [self.view.window.rootViewController presentViewController:matchVC animated:YES completion:nil];
    } else {
        [self prepareView];
    }

}

- (void)registerLikeOrPass:(BOOL)like {
    User* currentUserForMatching = [self currentUserForMatching];
    [self registerLikeOrPass:like forUser:currentUserForMatching];
}

- (void)didLike:(BOOL)like user:(User *)user {
    [self registerLikeOrPass:like forUser:user];
}

@end
