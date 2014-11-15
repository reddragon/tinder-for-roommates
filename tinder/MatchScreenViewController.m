//
//  MatchScreenViewController.m
//  tinder
//
//  Created by Gaurav Menghani on 11/10/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "MatchScreenViewController.h"
#import "User.h"
#import "SearchingForPeopleVC.h"
#import "ShowUserVC.h"
#import <Parse/Parse.h>

@interface MatchScreenViewController ()<ShowUserDelegate>
@property (strong, nonatomic) NSMutableArray* usersToShow;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) SearchingForPeopleVC* searchingVC;
@property (strong, nonatomic) ShowUserVC* showUserVC;
@end

@implementation MatchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Executing the query");
    
    self.searchingVC = [[SearchingForPeopleVC alloc] init];
    self.showUserVC = [[ShowUserVC alloc] init];
    self.showUserVC.delegate = self;
    
    self.searchingVC.view.frame = self.containerView.bounds;
    self.showUserVC.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.searchingVC.view];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    User* user = [User user];
    [query whereKey:@"fbid" notEqualTo:user.fbid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Objects size: %u", objects.count);
            NSMutableArray* newUsersToShow = [[NSMutableArray alloc] init];
            for (PFUser* foundUser in objects) {
                User* user = [[User alloc] initFromPFUser:foundUser];
                NSLog(@"Found user: %@", user.name);
                [newUsersToShow addObject:user];
            }
            [self showNewResultsWithUsers:newUsersToShow];
        } else {
            NSLog(@"Could not fetch users: %@", error);
        }
    }];
    
}

- (void) initiateSearching {
    // TODO
    // Remove people you have passed.
    [self.containerView addSubview:self.searchingVC.view];
}

- (void)onDoneWithUserList {
    [self initiateSearching];
}

- (void)showNewResultsWithUsers:(NSMutableArray *)users {
    [self.showUserVC addNewUsersToShow:users];
    [self.containerView addSubview:self.showUserVC.view];
    // self.containerView = self.showUserVC.view;
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

@end
