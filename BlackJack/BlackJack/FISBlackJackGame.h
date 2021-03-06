//
//  FISBlackJackGame.h
//  BlackJack
//
//  Created by Andrea McClave on 2/12/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISPlayingCardDeck.h"
#import "BlackJackPlayer.h"
#import "Bet.h"
#import "PlayingCard.h"

@interface FISBlackJackGame : NSObject

@property (strong, nonatomic) FISPlayingCardDeck *playingCardDeck;
@property (strong, nonatomic) BlackJackPlayer *player;
@property (strong, nonatomic) BlackJackPlayer *dealerPlayer;
@property (nonatomic) BOOL isDoubleDown;
@property (strong, nonatomic) NSNumber *chips;
@property (strong, nonatomic) NSNumber *currentBet;
@property (strong, nonatomic) NSNumber *cardCount;


- (id)init; // should initialize playingCardDeck with a new deck and set score and isBusted to default values
- (void)deal;
- (void)hit;
- (void)stay;
- (void)increaseCardCount;
- (void)decreaseCardCount;
- (void)countCard:(PlayingCard *)card;

@end
