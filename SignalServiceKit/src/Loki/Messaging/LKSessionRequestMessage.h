//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
// 

#import "LKFriendRequestMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKSessionRequestMessage : LKFriendRequestMessage

- (instancetype)initWithThread:(TSThread *)thread;

@end

NS_ASSUME_NONNULL_END
