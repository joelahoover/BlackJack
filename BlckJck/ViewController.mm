//
//  ViewController.m
//  BlckJck
//
//  Test comment
//
//  Created by Joel Hoover on 11/20/15.
//  Copyright (c) 2015 joelhoover. All rights reserved.
//

#import "ViewController.hh"
#import "Card.h"
#import "DeckOfCards.h"
#import "Hand.h"

@interface ViewController () {
    DeckOfCards deck;
    Hand playerHand;
}
@property (weak, nonatomic) IBOutlet UILabel *currentHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardBack;
@property (weak, nonatomic) IBOutlet UIImageView *cardFront;
@property (weak, nonatomic) IBOutlet UIImageView *duckWing;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *holdButton;


@end

@implementation ViewController

- (IBAction)hitMeButton:(id)sender {
    playerHand.Hit(deck.dealCard());
//    _currentHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
    
    //Disable additional button input while animation is running.
    self.hitButton.enabled = false;
    self.holdButton.enabled = false;
    
    //Rotate the duck flipper
    [UIView animateWithDuration:1.1
                          delay:0.0
                        options:(UIViewAnimationCurveEaseInOut)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         
                         self.duckWing.transform = CGAffineTransformMakeRotation(M_PI/-2);
                         //                         self.cardBack.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.5
                                               delay:0.0
                                             options:(UIViewAnimationCurveEaseInOut)
                                          animations:^{
                                              [UIView setAnimationDelegate:self];
                                              
                                              self.duckWing.transform = CGAffineTransformMakeRotation(M_PI);
                                              //                         self.cardBack.alpha = 0;
                                          }
                                           completion:nil];
                          }
     
     ];
    
    //Move card from the deck to the middle of the view
    [UIView animateWithDuration:1.1
                          delay:0.0
                        options:(UIViewAnimationCurveEaseInOut)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         
                         self.cardBack.center  = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
                         //                         self.cardBack.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              NSLog(@"Please get here");
                                              self.cardBack.frame = CGRectMake(self.view.bounds.size.width/2 - 25, self.view.bounds.size.height/2 - 40, 50, 80);
                                          }];
                     }
     
     ];

    
    
    //Allow the buttons to be hit again.
    self.hitButton.enabled = true;
    self.holdButton.enabled = true;
}

- (IBAction)holdButton:(id)sender {
    //_totalHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
    _totalHandLabel.text = [NSString stringWithFormat:@"%d", playerHand.getTotal() ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    deck.shuffle();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
