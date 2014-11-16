//
//  ShowUserVC.m
//  tinder
//
//  Created by Gaurav Menghani on 11/15/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ShowUserVC.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

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

- (void)addNewUsersToShow:(NSMutableArray*) users {
    
    // TODO Handle the case when
    // we are in the middle of browsing
    // and the users are found and
    // added.
    [self.usersToShow addObjectsFromArray:users];
    [self prepareView];
}

- (void)prepareView {
    User* userToShow = [self.usersToShow objectAtIndex:self.userIndex];
    [self.imgView setImageWithURL:userToShow.profileImageURL];
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

- (IBAction)onPass:(id)sender {
    // TODO
    // Register pass
    [self incrementIterator];
    [self prepareView];
}

- (IBAction)onLike:(id)sender {
    // TODO
    // Register like
    [self incrementIterator];
    [self prepareView];
}
@end
