//Card.h in Blackjack

#include <string>

#ifndef CARD_H
#define CARD_H

class Card
{
public: 

	int face;
	int suit;

	Card(int, int);//Constructor for Card Class; initializing "face" and "suit"
    
    
    std::string to_string() const;
};
#endif