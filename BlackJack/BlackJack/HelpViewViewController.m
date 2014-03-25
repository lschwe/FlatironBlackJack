//
//  HelpViewViewController.m
//  
//
//  Created by Dare Ryan on 3/3/14.
//
//

#import "HelpViewViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HelpViewViewController ()
- (IBAction)exitButtonIsPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *cardPointerLabel;
@property (strong, nonatomic) IBOutlet UILabel *betPointerLabel;
@property (strong, nonatomic) IBOutlet UILabel *holdSwipeLabel;
@property (strong, nonatomic) IBOutlet UILabel *deckPointerLabel;

@end

@implementation HelpViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = UIColorFromRGB(0x2ecc71);
    self.cardPointerLabel.attributedText = [[FAKFontAwesome handOLeftIconWithSize:20]attributedString];
    self.betPointerLabel.attributedText = [[FAKFontAwesome handOLeftIconWithSize:20]attributedString];
    self.holdSwipeLabel.attributedText = [[FAKFontAwesome arrowsHIconWithSize:30]attributedString];
    self.deckPointerLabel.attributedText = [[FAKFontAwesome handORightIconWithSize:20]attributedString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitButtonIsPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
