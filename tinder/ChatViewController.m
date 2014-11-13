//
//  ChatViewController.m
//  tinder
//
//  Created by Alan McConnell on 11/11/14.
//  Copyright (c) 2014 Foo Bar. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"

@interface ChatViewController ()

@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Chat";
    // self.title = self.match.name;
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQMessage alloc] initWithSenderId:self.senderId
                                        senderDisplayName:self.senderDisplayName
                                                     date:[NSDate distantPast]
                                                     text:@"Testing a message."],
                     
                     [[JSQMessage alloc] initWithSenderId:@"2"
                                        senderDisplayName:@"Mike"
                                                     date:[NSDate distantPast]
                                                     text:@"Hey, how are you?"],
                     
                     [[JSQMessage alloc] initWithSenderId:self.senderId
                                        senderDisplayName:self.senderDisplayName
                                                     date:[NSDate distantPast]
                                                     text:@"I'm great thanks!."],
                     
                     [[JSQMessage alloc] initWithSenderId:@"2"
                                        senderDisplayName:@"Mike"
                                                     date:[NSDate date]
                                                     text:@"Good!."],
                     nil
                     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)senderDisplayName {
    return @"Alan";
}

- (NSString *)senderId {
    return @"1";
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
    return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"avatar.jpg"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
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
    NSLog(@"hi");
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                             senderDisplayName:self.senderDisplayName
                                                          date:[[NSDate alloc] init]
                                                          text:@"Test"];
    
    [self.messages addObject:message];
    [self finishSendingMessage];
    //[self.collectionView reloadData];
}

@end