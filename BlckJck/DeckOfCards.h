//DeckOfCards.h for blackjack

#include <random>
#include <vector>
#include "Card.h"

#ifndef DECKOFCARDS_H
#define DECKOFCARDS_H

class DeckOfCards
{

public:

	std::vector<Card> deck;

	DeckOfCards();

	void shuffle();
    
    void repopulate();

	Card dealCard();

	bool moreCards();

};
#endif