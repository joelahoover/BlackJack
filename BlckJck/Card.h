//Card.h in Blackjack

#include <string>

#ifndef CARD_H
#define CARD_H

const static std::string faces [] = {"Ace", "Two","Three","Four","Five","Six","Seven", "Eight", "Nine", "Ten", "Jack","Queen","King"};
static const std::string suits [] = {"Clubs", "Diamonds", "Hearts", "Spades"};

class Card
{
public: 

	int face;
	int suit;

    Card(int inFace, int inSuit)//Constructor for Card Class; initializing "face" and "suit"
    {
        face = inFace;
        suit = inSuit;
    }
    
    
    std::string to_string()
    {
        //output << faces[card.face] << " of " << suits[card.suit];
        return faces[face] + std::string(" of ") + suits[suit];
    }
};
#endif