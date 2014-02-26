//
//  BlackjackGameViewController.m
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "BlackjackGameViewController.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BlackjackGameViewController ()
@property (strong, nonatomic) NSMutableArray *cardsInGame;


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
    self.cardsInGame = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    NSInteger cardWidth = 80;
    NSInteger cardHeight = 112;

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pokerFeltBackground320x568"]];
    self.view.backgroundColor = UIColorFromRGB(0x2cc36b);
    
    PlayingCardView *deckCard1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(40, 100, cardWidth, cardHeight) withRank:@"2" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(43, 103, cardWidth, cardHeight) withRank:@"3" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard3 = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:@"4" withSuit:@"♥" isVisible:NO];
//    PlayingCardView *dealerCardHidden = [[PlayingCardView alloc] initWithFrame:CGRectMake(170, 100, cardWidth, cardHeight) withRank:@"5" withSuit:@"♥" isVisible:NO];
//    PlayingCardView *dealerCardVisible = [[PlayingCardView alloc] initWithFrame:CGRectMake(185, 115, cardWidth, cardHeight) withRank:@"6" withSuit:@"♥" isVisible:YES];
//    PlayingCardView *playerCard1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:@"K" withSuit:@"♣" isVisible:NO];
//    PlayingCardView *playerCard2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(66, 106, cardWidth, cardHeight) withRank:@"A" withSuit:@"♣" isVisible:NO];
    
    [self.view addSubview:deckCard1];
    [self.view addSubview:deckCard2];
    [self.view addSubview:deckCard3];
//    [self.view addSubview:dealerCardHidden];
//    [self.view addSubview:dealerCardVisible];
//    [self.view addSubview:playerCard1];
//    [self.view addSubview:playerCard2];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        playerCard1.frame = CGRectMake(60, 300, cardWidth, cardHeight);
//    } completion:^(BOOL finished){
//        [playerCard1 flipCard];
//        [UIView animateWithDuration:0.3 animations:^{
//            playerCard2.frame = CGRectMake(80, 320, cardWidth, cardHeight);
//        } completion:^(BOOL finished){
//            [playerCard2 flipCard];
//        }];
//    }];
    
    FAKFontAwesome *plusIcon = [FAKFontAwesome plusSquareOIconWithSize:25];
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(220,320,25,25)];
    plusButton.titleLabel.textColor = [UIColor whiteColor];
    [plusButton setAttributedTitle:[plusIcon attributedString] forState:UIControlStateNormal];
    [self.view addSubview:plusButton];
    
    FAKFontAwesome *chipIcon = [FAKFontAwesome certificateIconWithSize:50];
    UIButton *chipButton = [[UIButton alloc] initWithFrame:CGRectMake(207,350,50,50)];
    chipButton.titleLabel.textColor = [UIColor whiteColor];
    [chipButton setAttributedTitle:[chipIcon attributedString] forState:UIControlStateNormal];
    [self.view addSubview:chipButton];
    
    FAKFontAwesome *minusIcon = [FAKFontAwesome minusSquareOIconWithSize:25];
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(220,410,25,25)];
    minusButton.titleLabel.textColor = [UIColor whiteColor];
    [minusButton setAttributedTitle:[minusIcon attributedString] forState:UIControlStateNormal];
    [self.view addSubview:minusButton];
    
    FAKFontAwesome *questionIcon = [FAKFontAwesome questionIconWithSize:25];
    UIButton *questionButton = [[UIButton alloc] initWithFrame:CGRectMake(220,450,25,25)];
    questionButton.titleLabel.textColor = [UIColor whiteColor];
    [questionButton setAttributedTitle:[questionIcon attributedString] forState:UIControlStateNormal];
    [self.view addSubview:questionButton];
    
    FAKFontAwesome *gearIcon = [FAKFontAwesome cogIconWithSize:25];
    UIButton *gearButton = [[UIButton alloc] initWithFrame:CGRectMake(220,480,25,25)];
    gearButton.titleLabel.textColor = [UIColor whiteColor];
    [gearButton setAttributedTitle:[gearIcon attributedString] forState:UIControlStateNormal];
    [self.view addSubview:gearButton];
    
    FAKFontAwesome *bulbIcon = [FAKFontAwesome lightbulbOIconWithSize:25];
    UIButton *bulbButton = [[UIButton alloc] initWithFrame:CGRectMake(220,510,25,25)];
    bulbButton.titleLabel.textColor = [UIColor whiteColor];
    [bulbButton setAttributedTitle:[bulbIcon attributedString] forState:UIControlStateNormal];
    [self.view addSubview:bulbButton];
    
    
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
    NSInteger cardWidth = 80;
    NSInteger cardHeight = 112;
    
    
    PlayingCard *playerCard = [self.blackJackGame.player.hand lastObject];
    NSString *playerCardRank = [playerCard formattedCardRank];
    NSString *playerCardSuit = playerCard.suit;
    
    
    PlayingCardView *playerCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:playerCardRank withSuit:playerCardSuit isVisible:NO];
    
    [self.cardsInGame addObject:playerCardView];
    [self.view addSubview:playerCardView];
    
    CGFloat xcoord = 0;
    CGFloat ycoord = 0;
    
    for (PlayingCardView *card in self.cardsInGame) {
        if (card.frame.origin.y >= 300) {
            if (card.frame.origin.x > xcoord) {
                xcoord = card.frame.origin.x;
                ycoord = card.frame.origin.y;
            }
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        playerCardView.frame = CGRectMake(xcoord+20, ycoord+20, cardWidth, cardHeight);
    } completion:^(BOOL finished){
        [playerCardView flipCard];
        [playerCardView tiltCardRandomly];
    }];
    
//    if([self.blackJackGame.player.hand count] > 2) {
//        self.card3.text = [self.blackJackGame.player.hand[2] description];
//        self.card3.hidden = NO;
//
//    }
//    if([self.blackJackGame.player.hand count] > 3) {
//        self.card4.text = [self.blackJackGame.player.hand[3] description];
//        self.card4.hidden = NO;
//    }
//    if([self.blackJackGame.player.hand count] > 4) {
//        self.card5.text = [self.blackJackGame.player.hand[4] description];
//        self.card5.hidden = NO;
//    }
    
    [self updateLabels];
}

- (IBAction)deal:(id)sender {
    
    NSInteger cardWidth = 80;
    NSInteger cardHeight = 112;
    
    self.hitButton.enabled = YES;
    self.stayButton.enabled = YES;
//    self.card3.hidden = YES;
//    self.card4.hidden = YES;
//    self.card5.hidden = YES;
    self.result.hidden = YES;
    
    if ([self.blackJackGame.playingCardDeck.cards count] < 20) {
        CGFloat chipCount = [self.blackJackGame.chips floatValue];
        self.blackJackGame = [FISBlackJackGame new];
        self.blackJackGame.chips = @(chipCount);
        self.result.text = @"Fresh Deck";
        self.result.hidden = NO;
    }
    for (PlayingCardView *cardToTrash in self.cardsInGame) {
        [cardToTrash removeFromSuperview];
    }
    
    self.cardsInGame = [[NSMutableArray alloc] init];
    
    [self.blackJackGame deal];
    NSString *playerCard1Rank = [self.blackJackGame.player.hand[0] formattedCardRank];
    NSString *playerCard2Rank = [self.blackJackGame.player.hand[1] formattedCardRank];
    PlayingCard *playerCard1 = self.blackJackGame.player.hand[0];
    NSString *playerCard1Suit = playerCard1.suit;
    PlayingCard *playerCard2 = self.blackJackGame.player.hand[1];
    NSString *playerCard2Suit = playerCard2.suit;
    
    NSString *dealerCard1Rank = [self.blackJackGame.dealerPlayer.hand[0] formattedCardRank];
    NSString *dealerCard2Rank = [self.blackJackGame.dealerPlayer.hand[1] formattedCardRank];
    PlayingCard *dealerCard1 = self.blackJackGame.dealerPlayer.hand[0];
    NSString *dealerCard1Suit = dealerCard1.suit;
    PlayingCard *dealerCard2 = self.blackJackGame.dealerPlayer.hand[1];
    NSString *dealerCard2Suit = dealerCard2.suit;
    
    PlayingCardView *playerCardView1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:playerCard1Rank withSuit:playerCard1Suit isVisible:NO];
    PlayingCardView *playerCardView2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:playerCard2Rank withSuit:playerCard2Suit isVisible:NO];
    
    
    PlayingCardView *dealerCardView1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:dealerCard1Rank withSuit:dealerCard1Suit isVisible:NO];
    PlayingCardView *dealerCardView2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:dealerCard2Rank withSuit:dealerCard2Suit isVisible:NO];
    
    [self.view addSubview:playerCardView1];
    [self.view addSubview:playerCardView2];
    [self.view addSubview:dealerCardView1];
    [self.view addSubview:dealerCardView2];
    [self.cardsInGame addObjectsFromArray:@[playerCardView1,playerCardView2,dealerCardView1,dealerCardView2]];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        playerCardView1.frame = CGRectMake(40, 300, cardWidth, cardHeight);
    } completion:^(BOOL finished){
        [playerCardView1 flipCard];
        [playerCardView1 tiltCardRandomly];
        [UIView animateWithDuration:0.3 animations:^{
            dealerCardView1.frame = CGRectMake(150, 100, cardWidth, cardHeight);
        } completion:^(BOOL finished){
            [dealerCardView1 tiltCardRandomly];
            [UIView animateWithDuration:0.3 animations:^{
                playerCardView2.frame = CGRectMake(60, 320, cardWidth, cardHeight);
            } completion:^(BOOL finished){
                [playerCardView2 flipCard];
                [playerCardView2 tiltCardRandomly];
                [UIView animateWithDuration:0.3 animations:^{
                    dealerCardView2.frame = CGRectMake(170, 120, cardWidth, cardHeight);
                } completion:^(BOOL finished){
                    [dealerCardView2 flipCard];
                    [dealerCardView2 tiltCardRandomly];
                }];
            }];
        }];
    }];
//    
//    self.card1.text = [self.blackJackGame.player.hand[0] description];
//    self.card2.text = [self.blackJackGame.player.hand[1] description];
//    self.card1.hidden = NO;
//    self.card2.hidden = NO;
    
    [self updateLabels];
    NSLog(@"Player has %@ chips and is currently betting %@", self.blackJackGame.chips, self.blackJackGame.currentBet);
}

- (IBAction)stay:(id)sender {
    NSInteger cardWidth = 80;
    NSInteger cardHeight = 112;
    
    [self.blackJackGame stay];
    self.stayButton.enabled = NO;
    
    PlayingCardView *dealerHiddenCard = self.cardsInGame[2];
    [dealerHiddenCard flipCard];
    
    CGFloat xcoord = 170;
    CGFloat ycoord = 120;
    
    if ([self.blackJackGame.dealerPlayer.hand count]>2) {
        for (NSInteger i = 2; i < [self.blackJackGame.dealerPlayer.hand count]; i++) {
            xcoord = xcoord +20;
            ycoord = ycoord +20;
            
            PlayingCard *dealerCard = self.blackJackGame.dealerPlayer.hand[i];
            NSString *dealerCardRank = [dealerCard formattedCardRank];
            NSString *dealerCardSuit = dealerCard.suit;
            
            PlayingCardView *dealerCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(46, 106, cardWidth, cardHeight) withRank:dealerCardRank withSuit:dealerCardSuit isVisible:NO];
            
            [self.cardsInGame addObject:dealerCardView];
            [self.view addSubview:dealerCardView];
            
            [UIView animateWithDuration:0.3 animations:^{
                dealerCardView.frame = CGRectMake(xcoord, ycoord, cardWidth, cardHeight);
            } completion:^(BOOL finished){
                [dealerCardView flipCard];
                [dealerCardView tiltCardRandomly];
            }];
        }
    }
    
    
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
    
    self.chipCountLabel.text = [NSString stringWithFormat:@"%@", @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue])];
}

- (void)updateLabels
{
    self.score.text = [NSString stringWithFormat:@"%@", self.blackJackGame.player.handScore];
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    [self.currentBetLabel setTitle:[NSString stringWithFormat:@"%@",self.blackJackGame.currentBet] forState:UIControlStateNormal];
    self.chipCountLabel.text = [NSString stringWithFormat:@"%@", @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue])];
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

- (IBAction)lessBet:(id)sender {
    NSInteger bet = [self.blackJackGame.currentBet integerValue];
    if (bet-1 != 0) {
        self.blackJackGame.currentBet = @(bet-1);
    }
    [self updateLabels];
}

- (IBAction)moreBet:(id)sender {
    NSInteger bet = [self.blackJackGame.currentBet integerValue];
    if (bet+1 <= [self.blackJackGame.chips integerValue]) {
        self.blackJackGame.currentBet = @(bet+1);
    }
    [self updateLabels];
}
@end
