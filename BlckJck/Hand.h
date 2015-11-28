//Hand.h in Blackjack

#include <vector>
#include "Card.h"

#ifndef HAND_H
#define HAND_H

class Hand
{

	bool Blackjack;
	int total;

public:

	std::vector<Card> myHand;

	//player functions
	void Hit(Card);

	void Hold();

	//helper functions
	void validateHand();

	//getters
	int getTotal();

	bool hasBlackjack();
    
	std::string to_string();
};

#endif