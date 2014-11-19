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

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
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
    self.userIndex = 0;
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
    User* userToShow = [self currentUserForMatching];
    if (userToShow.profileImage == nil) {
        NSLog(@"Manually setting the image for user: %@", userToShow.name);
        [self.imgView setImageWithURL:userToShow.profileImageURL];
    } else {
        NSLog(@"Setting the image for user: %@ from cache", userToShow.name);
        [self.imgView setImage:userToShow.profileImage];
    }
    [self.nameLabel setText:userToShow.name];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)incrementIterator {
    if (self.userIndex + 1>= self.usersToShow.count) {
        NSLog(@"Ran out of profiles to show!");
        if (self.delegate != nil) {
            [self.delegate onDoneWithUserList];
        }
    } else {
        self.userIndex++;
    }
}

- (User*)currentUserForMatching {
    User* userToShow = [self.usersToShow objectAtIndex:self.userIndex];
    return userToShow;
}

- (void)registerLikeOrPass:(BOOL)like {
    PFObject* match = [[PFObject alloc] initWithClassName:@"matches"];
    match[@"from"] = [[User user] pfUser];
    match[@"from_fbid"] = [[User user] fbid];
    
    User* currentUserForMatching = [self currentUserForMatching];
    
    match[@"to"] = [currentUserForMatching pfUser];
    match[@"to_fbid"] = [currentUserForMatching fbid];
    match[@"matched"] = @(like);
    [match saveInBackground];
    
    [self incrementIterator];
    
    // if (true) {
    if (like && [currentUserForMatching likesUs]) {
        ShowMatchVC* matchVC = [[ShowMatchVC alloc] initWithMatchingUser:currentUserForMatching];
        
        // FooBarViewController* matchVC = [[FooBarViewController alloc]init];
        [self.view.window.rootViewController presentViewController:matchVC animated:YES completion:nil];
    } else {
        [self prepareView];
    }
}

- (IBAction)onPass:(id)sender {
    [self registerLikeOrPass:NO];
}

- (IBAction)onLike:(id)sender {
    [self registerLikeOrPass:YES];
}
@end
