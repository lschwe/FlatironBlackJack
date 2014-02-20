//
//  FISPlayingCardDeck.m
//  BlackJack
//
//  Created by Andrea McClave on 2/12/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "FISPlayingCardDeck.h"
#import "FISDeck.h"
#import "PlayingCard.h"

@implementation FISPlayingCardDeck


-(id)init
{
    NSMutableArray *playingCards = [NSMutableArray new];
    for (NSInteger i = 1; i <= 13; i++)
    {
        PlayingCard *newCard = [[PlayingCard alloc]initWithRank:@(i) Suit:@"♥"];
        [playingCards addObject:newCard];
    }
    for (NSInteger i = 1; i <= 13; i++)
    {
        PlayingCard *newCard = [[PlayingCard alloc]initWithRank:@(i) Suit:@"♠"];
        [playingCards addObject:newCard];
    }
    for (NSInteger i = 1; i <= 13; i++)
    {
        PlayingCard *newCard = [[PlayingCard alloc]initWithRank:@(i) Suit:@"♣"];
        [playingCards addObject:newCard];
    }   for (NSInteger i = 1; i <= 13; i++)
    {
        PlayingCard *newCard = [[PlayingCard alloc]initWithRank:@(i) Suit:@"♦"];
        [playingCards addObject:newCard];
    }
    
   
    
    self = [super initWithCards:playingCards];
    
    return self;
}

/* CASTING
//functionality put in base class so that you don't have to reimplement in each different type of cards;
Card *card = [self.playingCardDeck drawRandomCard];
if ([card isKindOfClass: [PlayingCard Class]])
{
    PlayingCard *playingCard = (PlayingCard *) card; 
    playingCard.suit;
}
*/

@end
