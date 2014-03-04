//
//  BlackjackGameViewController.h
//  BlackJack
//
//  Created by Andrea McClave on 2/14/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBlackJackGame.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <CWStatusBarNotification.h>



@interface BlackjackGameViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *dealerScore;
@property (weak, nonatomic) IBOutlet UILabel *result;

@property (weak, nonatomic) IBOutlet UIButton *currentBetLabel;
@property (weak, nonatomic) IBOutlet UILabel *chipCountLabel;

- (IBAction)hit:(id)sender;
- (IBAction)deal:(id)sender;
- (IBAction)stay:(id)sender;

- (IBAction)hintTapped:(id)sender;
@end
