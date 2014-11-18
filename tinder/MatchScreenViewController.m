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
    
    // Get the people I have seen before. These can be either
    // the people I 'like'd or 'pass'ed.
    PFQuery *seenBeforeQuery = [PFQuery queryWithClassName:@"matches"];
    [seenBeforeQuery whereKey:@"from" equalTo:[User pfUser]];
    [seenBeforeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Num Objects: %d", objects.count);
            NSMutableArray* usersToExclude = [[NSMutableArray alloc] init];
            for (PFObject* match in objects) {
                NSLog(@"Seen: %@", match[@"to_fbid"]);
                [usersToExclude addObject:match[@"to_fbid"]];
            }
            
            // Add myself to the users to exclude as well.
            [usersToExclude addObject:[[User user] fbid]];
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            // [query whereKey:@"fbid" notContainedIn:usersToExclude];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSMutableArray* newUsersToShow = [[NSMutableArray alloc] init];
                    NSMutableDictionary* newUserFBIds = [[NSMutableDictionary alloc] init];
                    for (PFUser* foundUser in objects) {
                        User* user = [[User alloc] initFromPFUser:foundUser];
                        [newUsersToShow addObject:user];
                        newUserFBIds[user.fbid] = user;
                    }
                    
                    PFQuery *findMatches = [PFQuery queryWithClassName:@"matches"];
                    [findMatches whereKey:@"to_fbid" equalTo:[[User user] fbid]];
                    [findMatches whereKey:@"from_fbid" containedIn:[newUserFBIds allKeys]];
                    [findMatches findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            NSLog(@"Number of potential results: %d", objects.count);
                            for (PFObject* potentialMatch in objects) {
                                NSString* fbid = potentialMatch[@"from_fbid"];
                                User* user = newUserFBIds[fbid];
                                if (user) {
                                    NSLog(@"id: %@ likes: %@", fbid, potentialMatch[@"matched"]);
                                    user.likesUs = [potentialMatch[@"matched"] boolValue];
                                }
                            }
                            [self showNewResultsWithUsers:newUsersToShow];
                        } else {
                            NSLog(@"Some problem while finding mutual matches %@", error);
                        }
                    }];
                } else {
                    NSLog(@"Could not make the second query to fetch actual users!");
                }
            }];
            
        } else {
            NSLog(@"Had some problem while getting people we have seen before: %@", error);
        }
    }]; 
}

- (void) initiateSearching {
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

- (ViewType)viewType {
    return MatchView;
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
