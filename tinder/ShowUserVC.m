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

@property (strong, nonatomic) MatchUserView *matchUserView;

- (IBAction)onPass:(id)sender;
- (IBAction)onLike:(id)sender;

@property (strong, nonatomic) NSMutableArray* usersToShow;
@property NSUInteger userIndex;

@end

@implementation ShowUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usersToShow = [[NSMutableArray alloc] init];
    
    self.matchUserView = [[MatchUserView alloc] initWithFrame:CGRectMake(10, 20, 300, 300)];
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
        
        // FooBarViewController* matchVC = [[FooBarViewController alloc]init];
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

- (IBAction)onPass:(id)sender {
    [self registerLikeOrPass:NO];
}

- (IBAction)onLike:(id)sender {
    [self registerLikeOrPass:YES];
}
@end
