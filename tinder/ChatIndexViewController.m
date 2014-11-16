//
//  ChatIndexViewController.m
//  tinder
//
//  Created by Alan McConnell on 11/13/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ChatIndexViewController.h"
#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "Match.h"
#import "User.h"

@interface ChatIndexViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *matches;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ChatIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 76;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self loadTable];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadTable];
}

- (void)onRefresh {
    MainViewController *parent = (MainViewController *)self.parentViewController;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         parent.chatButton.transform = CGAffineTransformMakeScale(1.6, 1.6);
                     }
                     completion:nil];
    [self loadTableWithCompletion:^{
        [parent.chatButton.layer removeAllAnimations];
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             parent.chatButton.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:nil];
    }];
}

- (void)loadTableWithCompletion:(void(^)(void))completion {
    [[User user] matchesWithCompletion:^(NSArray *matches) {
        self.matches = matches;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        if (completion != nil) {
            completion();
        }
    }];
}
     
- (void)loadTable {
    [self loadTableWithCompletion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    Match *match = self.matches[indexPath.row];
    cell.user = match.match;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.matches[indexPath.row];
    ChatViewController *cvc = [[ChatViewController alloc] init];
    cvc.match = match.match;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    NSLog(@"%@", self.parentViewController);
    [self.parentViewController presentViewController:nvc animated:YES completion:nil];
}

- (ViewType)viewType {
    return ChatView;
}
@end
