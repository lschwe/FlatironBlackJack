//
//  BlackjackGameViewController.h
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBlackJackGame.h"

@interface BlackjackGameViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *card1;
@property (weak, nonatomic) IBOutlet UILabel *card2;
@property (weak, nonatomic) IBOutlet UILabel *card3;
@property (weak, nonatomic) IBOutlet UILabel *card4;
@property (weak, nonatomic) IBOutlet UILabel *card5;
@property (strong, nonatomic) FISBlackJackGame *blackJackGame;

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *dealerScore;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *stayButton;
@property (strong, nonatomic) IBOutlet UILabel *dealerFirstCard;
@property (weak, nonatomic) IBOutlet UIButton *currentBetLabel;
@property (weak, nonatomic) IBOutlet UILabel *chipCountLabel;

- (IBAction)hit:(id)sender;
- (IBAction)deal:(id)sender;
- (IBAction)stay:(id)sender;
- (IBAction)lessBet:(id)sender;
- (IBAction)moreBet:(id)sender;

@end
