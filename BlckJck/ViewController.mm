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

@end

@implementation ViewController

- (IBAction)hitMeButton:(id)sender {
    playerHand.Hit(deck.dealCard());
    _currentHandLabel.text = [NSString stringWithCString:playerHand.to_string().c_str() encoding:[NSString defaultCStringEncoding]];
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
