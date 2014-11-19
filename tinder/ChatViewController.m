//
//  ChatViewController.m
//  tinder
//
//  Created by Alan McConnell on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "UIImageView+AFNetworking.h"

@interface ChatViewController ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    self.messages = [NSMutableArray array];
    
    [self loadMessages];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 132, 40)];
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 40, 40)];
    [profileImageView setImageWithURL:self.match.profileImageURL placeholderImage:[UIImage imageNamed:@"Profile"]];
    
    CGFloat cornerRadius = profileImageView.frame.size.width / 2;
    
    profileImageView.layer.cornerRadius = cornerRadius;
    [profileImageView.layer setMasksToBounds:YES];
    profileImageView.clipsToBounds = YES;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 80, 40)];
    nameLabel.text = self.match.first_name;
    
    [titleView addSubview:profileImageView];
    [titleView addSubview:nameLabel];
    
    self.navigationItem.titleView = titleView;
    
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(loadMessages)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.messages = nil;
    if (self.timer != nil) {
        [self.timer invalidate];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadMessages {
    [[User user] messagesWithUser:self.match withCompletion:^(NSArray *messages) {
        self.messages = [NSMutableArray arrayWithArray:messages];
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)senderDisplayName {
    return [User user].name;
}

- (NSString *)senderId {
    return [User user].fbid;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    }
    
    return [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    UIImageView *avatar = [[UIImageView alloc] init];
    UIImage *defaultAvatar = [UIImage imageNamed:@"Profile"];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        [avatar setImageWithURL:[User user].profileImageURL placeholderImage:defaultAvatar];
    } else {
        [avatar setImageWithURL:self.match.profileImageURL placeholderImage:defaultAvatar];
    }
    
    return [JSQMessagesAvatarImageFactory avatarImageWithImage:avatar.image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    Message *message = [[Message alloc] initWithSender:self.senderId
                                             recipient:self.match.fbid
                                     senderDisplayName:[User user].name
                                                  text:text date:date];
    [self.messages addObject:message];
    [message saveInBackgroundWithCompletion:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"%@", error);
        }
    }];
    
    if (self.matchID != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"matches"];
        [query getObjectInBackgroundWithId:self.matchID block:^(PFObject *match, NSError *error) {
            match[@"last_message"] = text;
            [match saveInBackground];
        }];
    }
    [self finishSendingMessage];
}

@end