//
//  BlackjackGameViewController.m
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "BlackjackGameViewController.h"
#import "PlayingCard.h"

@interface BlackjackGameViewController ()




@end

@implementation BlackjackGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.blackJackGame = [[FISBlackJackGame alloc] init];
    
    
    [self deal:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hit:(id)sender {
    NSLog(@"Hit was tapped");
    [self.blackJackGame hit];
    if([self.blackJackGame.player.hand count] > 2) {
        self.card3.text = [self.blackJackGame.player.hand[2] description];
        self.card3.hidden = NO;

    }
    if([self.blackJackGame.player.hand count] > 3) {
        self.card4.text = [self.blackJackGame.player.hand[3] description];
        self.card4.hidden = NO;
    }
    if([self.blackJackGame.player.hand count] > 4) {
        self.card5.text = [self.blackJackGame.player.hand[4] description];
        self.card5.hidden = NO;
    }
    
    [self updateLabels];
}

- (IBAction)deal:(id)sender {
    
    self.hitButton.enabled = YES;
    self.stayButton.enabled = YES;
    self.card3.hidden = YES;
    self.card4.hidden = YES;
    self.card5.hidden = YES;
    self.result.hidden = YES;
    
    if ([self.blackJackGame.playingCardDeck.cards count] < 20) {
        CGFloat chipCount = [self.blackJackGame.chips floatValue];
        self.blackJackGame = [FISBlackJackGame new];
        self.blackJackGame.chips = @(chipCount);
        self.result.text = @"Fresh Deck";
        self.result.hidden = NO;
    }
    
    NSLog(@"Deal was tapped");
    [self.blackJackGame deal];
    self.card1.text = [self.blackJackGame.player.hand[0] description];
    self.card2.text = [self.blackJackGame.player.hand[1] description];
    self.card1.hidden = NO;
    self.card2.hidden = NO;
    
    [self updateLabels];
    NSLog(@"Player has %@ chips and is currently betting %@", self.blackJackGame.chips, self.blackJackGame.currentBet);
}

- (IBAction)stay:(id)sender {
    [self.blackJackGame stay];
    self.stayButton.enabled = NO;
    NSString *winner = @"";
    CGFloat multiple = 1;
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    if (([self.blackJackGame.player.handScore integerValue] > [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) || (self.blackJackGame.dealerPlayer.isBusted == YES && self.blackJackGame.player.isBusted == NO)) {
        if (self.blackJackGame.player.isBlackjack) {
            self.result.text = @"Player Wins with Black Jack!";
            winner = @"Player";
        } else {
            self.result.text = @"Player Wins";
            winner = @"Player";
        }
        self.result.hidden = NO;
    } else if ([self.blackJackGame.player.handScore integerValue] == [self.blackJackGame.dealerPlayer.handScore integerValue] && self.blackJackGame.player.isBusted == NO) {
        self.result.text = @"Push";
        self.result.hidden = NO;
    } else {
        if (self.blackJackGame.player.isBusted) {
            self.result.text = @"Player Busted and Dealer Wins";
            winner = @"Dealer";
        } else {
            self.result.text = @"Dealer Wins";
            winner = @"Dealer";
        }
        self.result.hidden = NO;
    }
    
    if ([winner isEqualToString:@"Player"]) {
        if (self.blackJackGame.player.isBlackjack) {
            multiple = 1.5;
        }
        self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] + [self.blackJackGame.currentBet floatValue]*multiple);
        NSLog(@"Player has won %@ chips. Now he has %@", @([self.blackJackGame.currentBet floatValue]*multiple), self.blackJackGame.chips);
    } else if ([winner isEqualToString:@"Dealer"]){
        self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue]);
        NSLog(@"Player has lost %@ chips. Now he has %@", self.blackJackGame.currentBet, self.blackJackGame.chips);
    } else {
        NSLog(@"Push. Player keeps his %@ chips", self.blackJackGame.chips);
    }
}

- (void)updateLabels
{
    self.score.text = [NSString stringWithFormat:@"%@", self.blackJackGame.player.handScore];
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    PlayingCard *dealerCard = self.blackJackGame.dealerPlayer.hand[0];
    self.dealerFirstCard.text = [NSString stringWithFormat:@"%@", dealerCard.rank];
    if (self.blackJackGame.player.isBlackjack) {
        self.result.text = @"Blackjack!";
        self.result.hidden = NO;
        self.hitButton.enabled = NO;
        [self stay:nil];
    }
    
    if (self.blackJackGame.player.isBusted) {
        self.result.text = @"Busted!";
        self.result.hidden = NO;
        self.hitButton.enabled = NO;
        [self stay:nil];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertView *shakeAlert = [[UIAlertView alloc]initWithTitle:@"Do you want to change tables?" message:@"Click OK to quit the current game and deal fresh decks" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [shakeAlert show];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex){
        
    }else{
        [self.blackJackGame.playingCardDeck.cards removeAllObjects];
        [self deal:nil];
    }
}

@end
