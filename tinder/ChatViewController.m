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

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Create the timer object
    /*
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(loadMessages)
                                   userInfo:nil
                                    repeats:YES];
     */
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadMessages];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadMessages {
    [[User user] messagesWithUser:self.match.match withCompletion:^(NSArray *messages) {
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
    
    return [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    UIImageView *avatar = [[UIImageView alloc] init];
    UIImage *defaultAvatar = [UIImage imageNamed:@"Profile"];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        [avatar setImageWithURL:[User user].profileImageURL placeholderImage:defaultAvatar];
    } else {
        [avatar setImageWithURL:self.match.match.profileImageURL placeholderImage:defaultAvatar];
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
                                             recipient:self.match.match.fbid
                                     senderDisplayName:[User user].name
                                                  text:text date:date];
    [self.messages addObject:message];
    [message saveInBackgroundWithCompletion:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"%@", error);
        }
    }];
    PFQuery *query = [PFQuery queryWithClassName:@"matches"];
    [query getObjectInBackgroundWithId:self.match.matchID block:^(PFObject *match, NSError *error) {
        match[@"last_message"] = text;
        [match saveInBackground];
    }];
    [self finishSendingMessage];
}

@end