//
//  ViewController.m
//  BlckJck
//
//  Test comment
//  Kyle- 2015
//
//  Created by Joel Hoover on 11/20/15.
//  Copyright (c) 2015 joelhoover. All rights reserved.
//

#import "ViewController.hh"
#import "Card.h"
#import "DeckOfCards.h"
#import "Hand.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewController () {
    DeckOfCards deck;
    Hand playerHand;
    Hand dealerHand;
    
    NSMutableArray* playerHandImages;
    UIImageView* prevCard;
}
@property (weak, nonatomic) IBOutlet UILabel *currentHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourHandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardBack;
@property (weak, nonatomic) IBOutlet UIImageView *cardFront;
@property (weak, nonatomic) IBOutlet UIImageView *duckWing;
@property (weak, nonatomic) IBOutlet UIImageView *winLoseImage;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *holdButton;
@property (weak, nonatomic) IBOutlet UIImageView *sizedBack;
@property (weak, nonatomic) IBOutlet UILabel *dealerHandLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    deck.shuffle();
    playerHandImages = [NSMutableArray arrayWithObjects:nil];
    self.cardBack.transform = CGAffineTransformMakeRotation(.35);
}

//I cannot for the life of me seem to get the completion blocks working, so if anyone knows how to do that let me know (kyle)
- (IBAction)hitMeButton:(id)sender {
    //Declaring a variable to hold the top card.
    Card topCard = deck.dealCard();
    playerHand.Hit(topCard);
    
    //Defining the location for the frontImage view to appear.
    CGRect cardFrontLoc = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 80, 100, 160);
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:cardFrontLoc];
    [playerHandImages addObject:iv];
    NSLog(@"%@",playerHandImages);
    
    //Trying to fix the start point of the backFrame.
    self.sizedBack.frame = CGRectMake(342, 264, 42, 72);
    
    
    //Disable additional button input while animation is running.
    self.hitButton.enabled = false;
    self.holdButton.enabled = false;
    
    //Rotate the duck flipper and move the card.
    [UIView animateWithDuration:0.6f
                          delay:0.0f
                        options:(UIViewAnimationCurveEaseInOut)
                     animations:^{
                         
                         //Making a compound transformation. This is how you have to do it to rotate something around a point that isnt the center. This moves the center of the view to the rotation point, then rotates it, then translates the center back to the original.
                         CGAffineTransform transform = CGAffineTransformMakeTranslation(-77.5, -15);
                         transform = CGAffineTransformRotate(transform, M_PI/2);
                         transform = CGAffineTransformTranslate(transform, 77.5, 15);
                         self.duckWing.transform = transform;
                         
                         
                         self.sizedBack.center  = CGPointMake(self.view.bounds.size.width/2 , self.view.bounds.size.height/2 );
                         
                     }
                     completion:^(BOOL finished) {
                         //Return the duck wing to the original location and resize the back of the card view
                         [UIView animateWithDuration:0.9f
                                          animations:^{
                                              
                                              self.duckWing.transform = CGAffineTransformIdentity;
                                              self.sizedBack.frame = CGRectMake(self.view.bounds.size.width/2 - 35, self.view.bounds.size.height/2 - 80, 100, 160);
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              // Reveal the front of the card
                                              [self.view addSubview:iv];
                                              iv.image = [UIImage imageNamed:[NSString stringWithCString:topCard.to_string().c_str() encoding:[NSString defaultCStringEncoding]]];
                                              
                                              //Return the cardBack view to the top of the deck.
                                              self.cardBack.frame = CGRectMake(138, 204, 25, 40);
                                              
                                              [UIView animateWithDuration:0.6
                                                                    delay:0.3
                                                                  options:UIViewAnimationCurveEaseOut
                                                               animations:^{
                                                                   //Determines where each card should be put based on the new hand size.
                                                                   unsigned long numCards = playerHand.myHand.size();
                                                                   for (int i=0; i<numCards; i++) {
                                                                       int newX = 17 + (self.view.bounds.size.width - 92) * i / ((numCards<=5)?4:numCards-1);
                                                                       ((UIImageView*)[playerHandImages objectAtIndex:i]).frame = CGRectMake(newX, 510, 60, 96);
                                                                   }
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   //Updates the text that displays your hand score
                                                                   _yourHandLabel.text = [@"Your Hand: " stringByAppendingString:[NSString stringWithFormat:@"%i", playerHand.getTotal()]];
                                                                   
                                                                   self.hitButton.enabled = true; //Allow further input
                                                                   self.holdButton.enabled = true;
                                                                   
                                                                   [self checkDeal];
                                                               }];
                                          }];
                     }
     ];
}

-(void) checkDeal {
    // Check if a player has busted
    if (playerHand.getTotal() > 21){
        [self displayWinLoseImage];
        return;
    }
}

- (IBAction)holdButton:(id)sender {
    while(dealerHand.getTotal() < 17) {
        Card topCard = deck.dealCard();
        dealerHand.Hit(topCard);
        _dealerHandLabel.text = [@"Dealer: " stringByAppendingString:[NSString stringWithFormat:@"%i", dealerHand.getTotal()]];
    }
  
    [self displayWinLoseImage];
    
}


-(void) displayWinLoseImage{
    UIImage *image  = [UIImage new];
    if ((playerHand.getTotal() > dealerHand.getTotal() && playerHand.getTotal() <= 21) || dealerHand.getTotal() > 21) {
        image = [UIImage imageNamed:@"WinDuck"];
        
    }
    else if (playerHand.getTotal() < dealerHand.getTotal() || playerHand.getTotal() > 21) {
        image = [UIImage imageNamed:@"SadLoseDuck"];
    }
    else {
        image = [UIImage imageNamed:@"TieImage"];
    }
    [self.winLoseImage setImage:image]; //Assigning the correct image to the view
    
    //Assigning the correct image to the view that shows the result, then brings it to the front and animates its resizing.
    
    //Sends subview to back.
    void (^completion)(void) = ^{
        [self.view sendSubviewToBack:self.winLoseImage];
    };
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.view bringSubviewToFront:self.winLoseImage];
                         self.winLoseImage.transform = CGAffineTransformMakeScale(1.25, 2.0); //Animated size increase
                     }
                     completion:^(BOOL finished) {
                         [NSThread sleepForTimeInterval:2.0f];
                         completion();
                         [self tryAgain];
                     }
     ];
}

- (IBAction)tryAgain {
    // Reset everything

    [UIView animateWithDuration:0.9f
                     animations:^{
                         unsigned long numCards = playerHand.myHand.size();
                         for (int i=0; i<numCards; i++) {
                            int newX = 517 + (self.view.bounds.size.width - 92) * i / ((numCards<=5)?4:numCards-1);
                             ((UIImageView*)[playerHandImages objectAtIndex:i]).frame = CGRectMake(newX, 510, 60, 96);
                         }
                     }
                     completion:nil
                    ];

    deck.repopulate();
    deck.shuffle();
    playerHand.clear();
    dealerHand.clear();
    playerHandImages = [NSMutableArray arrayWithObjects:nil];

    //Updates the text that displays the hand scores
    _yourHandLabel.text = [@"Your Hand: " stringByAppendingString:[NSString stringWithFormat:@"%i", playerHand.getTotal()]];
    _dealerHandLabel.text = [@"Dealer: " stringByAppendingString:[NSString stringWithFormat:@"%i", dealerHand.getTotal()]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
