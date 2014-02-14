//
//  PlayingCard.h
//  OOP-Cards-Model
//
//  Created by Andrea McClave on 2/10/14.
//  Copyright (c) 2014 Al Tyus. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (strong, nonatomic) NSNumber *rank;

- (NSString *)description;
- (id)initWithRank:(NSNumber *)rankNumber Suit:(NSString *)suitString;

@end
