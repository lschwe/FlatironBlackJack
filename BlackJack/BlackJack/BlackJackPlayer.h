//
//  BlackJackPlayer.h
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlackJackPlayer : NSObject

@property (strong, nonatomic) NSNumber *handScore;
@property (strong, nonatomic) NSMutableArray *hand;
@property (nonatomic) BOOL isBusted;
@property (nonatomic) BOOL isBlackjack;

@end
