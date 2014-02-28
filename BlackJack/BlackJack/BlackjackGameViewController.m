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

@interface BlackjackGameViewController () {
    CGRect dealerRect;
    CGRect playerRect;
    CGRect deckRect;
    NSInteger cardWidth;
    NSInteger cardHeight;

}
@property (strong, nonatomic) NSMutableArray *cardsInGame;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *helpBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hintBarButton;
@property (weak, nonatomic) IBOutlet UIButton *doubleDownButton;


- (IBAction)doubleDownTapped:(id)sender;
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
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
    self.notification.notificationLabelBackgroundColor = UIColorFromRGB(0x45A1CD);
    
	// Do any additional setup after loading the view.

    self.cardsInGame = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    cardWidth = 80;
    cardHeight = 112;
    dealerRect = CGRectMake(20, 100, cardWidth, cardHeight);
    playerRect = CGRectMake(20, 320, cardWidth, cardHeight);
    deckRect = CGRectMake(220, 106, cardWidth, cardHeight);
    [self.doubleDownButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    
    self.view.backgroundColor = UIColorFromRGB(0x2cc36b);
    
    PlayingCardView *deckCard1 = [[PlayingCardView alloc] initWithFrame:CGRectMake(deckRect.origin.x-6, deckRect.origin.y-6, cardWidth, cardHeight) withRank:@"2" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard2 = [[PlayingCardView alloc] initWithFrame:CGRectMake(deckRect.origin.x-3, deckRect.origin.y-3, cardWidth, cardHeight) withRank:@"3" withSuit:@"♥" isVisible:NO];
    PlayingCardView *deckCard3 = [[PlayingCardView alloc] initWithFrame:deckRect withRank:@"4" withSuit:@"♥" isVisible:NO];
    
    [self.view addSubview:deckCard1];
    [self.view addSubview:deckCard2];
    [self.view addSubview:deckCard3];
    
    FAKFontAwesome *plusIcon = [FAKFontAwesome plusSquareOIconWithSize:35];
    self.plusButton.titleLabel.textColor = [UIColor whiteColor];
    [self.plusButton setAttributedTitle:[plusIcon attributedString] forState:UIControlStateNormal];
    
    FAKFontAwesome *minusIcon = [FAKFontAwesome minusSquareOIconWithSize:35];
    self.minusButton.titleLabel.textColor = [UIColor whiteColor];
    [self.minusButton setAttributedTitle:[minusIcon attributedString] forState:UIControlStateNormal];
    
    FAKFontAwesome *questionIcon = [FAKFontAwesome questionIconWithSize:20];
    [questionIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImage = [questionIcon imageWithSize:CGSizeMake(20, 20)];
    self.helpBarButton.image = leftImage;
    
//    FAKFontAwesome *gearIcon = [FAKFontAwesome cogIconWithSize:25];
//    UIButton *gearButton = [[UIButton alloc] initWithFrame:CGRectMake(220,480,25,25)];
//    gearButton.titleLabel.textColor = [UIColor whiteColor];
//    [gearButton setAttributedTitle:[gearIcon attributedString] forState:UIControlStateNormal];
//    [self.view addSubview:gearButton];
    
    FAKFontAwesome *bulbIcon = [FAKFontAwesome lightbulbOIconWithSize:20];
    [bulbIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *rightImage = [bulbIcon imageWithSize:CGSizeMake(20, 20)];  
    self.hintBarButton.image = rightImage;
        
    self.blackJackGame = [[FISBlackJackGame alloc] init];
    
    
    [self deal:nil];
}
- (void)flashMessage
{
    NSLog(@"flashing");
    [self.notification displayNotificationWithMessage:@"Testing" forDuration:0.4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hit:(id)sender {
    NSLog(@"Hit was tapped");
    PlayingCardView *dealerHiddenCard = self.cardsInGame[2];
    if (!self.blackJackGame.player.isBusted && !dealerHiddenCard.isVisible) {
        [self.blackJackGame hit];
        
        PlayingCard *playerCard = [self.blackJackGame.player.hand lastObject];
        NSString *playerCardRank = [playerCard formattedCardRank];
        NSString *playerCardSuit = playerCard.suit;
        
        
        PlayingCardView *playerCardView = [[PlayingCardView alloc] initWithFrame:deckRect withRank:playerCardRank withSuit:playerCardSuit isVisible:NO];
        
        [self.cardsInGame addObject:playerCardView];
        [self.view addSubview:playerCardView];
        
        CGFloat xcoord = 0;
        CGFloat ycoord = 0;
        
        NSMutableArray *playerCardViews = [[NSMutableArray alloc] init];
        
        for (PlayingCardView *card in self.cardsInGame) {
            if (card.frame.origin.y >= 300) {
                [playerCardViews addObject:card];
            }
        }
        
        PlayingCardView *lastCard = [playerCardViews lastObject];
        xcoord = lastCard.frame.origin.x;
        ycoord = lastCard.frame.origin.y;
        
        if (xcoord>90) {
            xcoord = -10;
            ycoord = ycoord +20;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            playerCardView.frame = CGRectMake(xcoord+30, ycoord+10, cardWidth, cardHeight);
        } completion:^(BOOL finished){
            [playerCardView flipCard];
            [playerCardView tiltCardRandomly];
        }];
        [self updateLabels];
    }
}

- (IBAction)deal:(id)sender {
    
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
    
    PlayingCardView *playerCardView1 = [[PlayingCardView alloc] initWithFrame:deckRect withRank:playerCard1Rank withSuit:playerCard1Suit isVisible:NO];
    PlayingCardView *playerCardView2 = [[PlayingCardView alloc] initWithFrame:deckRect withRank:playerCard2Rank withSuit:playerCard2Suit isVisible:NO];
    
    
    PlayingCardView *dealerCardView1 = [[PlayingCardView alloc] initWithFrame:deckRect withRank:dealerCard1Rank withSuit:dealerCard1Suit isVisible:NO];
    PlayingCardView *dealerCardView2 = [[PlayingCardView alloc] initWithFrame:deckRect withRank:dealerCard2Rank withSuit:dealerCard2Suit isVisible:NO];
    
    [self.view addSubview:playerCardView1];
    [self.view addSubview:playerCardView2];
    [self.view addSubview:dealerCardView1];
    [self.view addSubview:dealerCardView2];
    [self.cardsInGame addObjectsFromArray:@[playerCardView1,playerCardView2,dealerCardView1,dealerCardView2]];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        playerCardView1.frame = playerRect;
    } completion:^(BOOL finished){
        [playerCardView1 flipCard];
        [playerCardView1 tiltCardRandomly];
        [UIView animateWithDuration:0.3 animations:^{
            dealerCardView1.frame = dealerRect;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 animations:^{
                playerCardView2.frame = CGRectMake(playerRect.origin.x+30, playerRect.origin.y+10, cardWidth, cardHeight);
            } completion:^(BOOL finished){
                [playerCardView2 flipCard];
                [playerCardView2 tiltCardRandomly];
                [UIView animateWithDuration:0.3 animations:^{
                    dealerCardView2.frame = CGRectMake(dealerRect.origin.x+30, dealerRect.origin.y+10, cardWidth, cardHeight);
                } completion:^(BOOL finished){
                    [dealerCardView2 flipCard];
                    [dealerCardView2 tiltCardRandomly];
                }];
            }];
        }];
    }];
    
    [self updateLabels];
    NSLog(@"Player has %@ chips and is currently betting %@", self.blackJackGame.chips, self.blackJackGame.currentBet);
}

- (IBAction)stay:(id)sender {
    PlayingCardView *dealerHiddenCard = self.cardsInGame[2];
    
    if (dealerHiddenCard.isVisible == NO) {
        [self.blackJackGame stay];
        [dealerHiddenCard flipCard];
        
        CGFloat xcoord = dealerRect.origin.x+30;
        CGFloat ycoord = dealerRect.origin.y+10;
        
        if ([self.blackJackGame.dealerPlayer.hand count]>2) {
            for (NSInteger i = 2; i < [self.blackJackGame.dealerPlayer.hand count]; i++) {
                if (xcoord>90) {
                    xcoord = -10;
                    ycoord = ycoord +20;
                }
                
                xcoord = xcoord +30;
                ycoord = ycoord +10;
                
                
                PlayingCard *dealerCard = self.blackJackGame.dealerPlayer.hand[i];
                NSString *dealerCardRank = [dealerCard formattedCardRank];
                NSString *dealerCardSuit = dealerCard.suit;
                
                PlayingCardView *dealerCardView = [[PlayingCardView alloc] initWithFrame:deckRect withRank:dealerCardRank withSuit:dealerCardSuit isVisible:NO];
                
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
                multiple = 1.5;
                winner = @"Player";
            } else {
                self.result.text = @"Player Wins!";
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
                PlayingCard *dealerVisibleCard = self.blackJackGame.dealerPlayer.hand[1];
                if (self.blackJackGame.dealerPlayer.isBlackjack && [dealerVisibleCard.rank isEqual:@1]) {
                    self.result.text = @"Dealer Wins with Black Jack :(";
                } else {
                    self.result.text = @"Dealer Wins :(";
                }
                winner = @"Dealer";
            }
            self.result.hidden = NO;
        }
        
        if ([winner isEqualToString:@"Player"]) {
            if (self.blackJackGame.isDoubleDown) {
                multiple = 2;
            }
            self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] + [self.blackJackGame.currentBet floatValue]*multiple);
            NSLog(@"Player has won %@ chips. Now he has %@", @([self.blackJackGame.currentBet floatValue]*multiple), self.blackJackGame.chips);
        } else if ([winner isEqualToString:@"Dealer"]){
            self.blackJackGame.chips = @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue]);
            NSLog(@"Player has lost %@ chips. Now he has %@", self.blackJackGame.currentBet, self.blackJackGame.chips);
        } else {
            NSLog(@"Push. Player keeps his %@ chips", self.blackJackGame.chips);
        }
        
        self.chipCountLabel.text = [NSString stringWithFormat:@"$%@", @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue])];
    }
}

- (void)updateLabels
{
    self.score.text = [NSString stringWithFormat:@"%@", self.blackJackGame.player.handScore];
    self.dealerScore.text = [NSString stringWithFormat:@"%@", self.blackJackGame.dealerPlayer.handScore];
    [self.currentBetLabel setTitle:[NSString stringWithFormat:@"$%@",self.blackJackGame.currentBet] forState:UIControlStateNormal];
    self.chipCountLabel.text = [NSString stringWithFormat:@"$%@", @([self.blackJackGame.chips floatValue] - [self.blackJackGame.currentBet floatValue])];
    
    PlayingCard *dealerVisibleCard = self.blackJackGame.dealerPlayer.hand[1];
    if (self.blackJackGame.player.isBlackjack) {
        self.result.hidden = NO;
        [self stay:nil];
    } else if (self.blackJackGame.dealerPlayer.isBlackjack && [dealerVisibleCard.rank isEqual:@1]){
        self.result.hidden = NO;
        [self stay:nil];
    }
    
    if (self.blackJackGame.player.isBusted) {
        self.result.hidden = NO;
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
- (IBAction)doubleDownTapped:(id)sender {
    self.blackJackGame.isDoubleDown = YES;
    
    [self hit:nil];
    [self stay:nil];
}
@end
