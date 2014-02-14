//
//  FISDeck.h
//  BlackJack
//
//  Created by Andrea McClave on 2/12/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface FISDeck : NSObject

@property (strong, nonatomic) NSMutableArray *cards;

- (Card *)drawRandomCard;
- (id)initWithCards: (NSMutableArray *)cards;

@end
