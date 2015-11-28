//DeckOfCards.cpp for blackjack

#include <random>
#include <vector>
#include "Card.h"
#include "DeckOfCards.h"

std::random_device rd;
std::mt19937 gen(rd());
std::uniform_int_distribution<> dist(0, 51);

DeckOfCards::DeckOfCards()//initialzing a full deck of cards
{
	for(int s = 0; s < 4; s++){
		for(int f = 0; f < 13; f++){
			deck.push_back( Card(f, s) );
		}
	}
}

void DeckOfCards::shuffle()//shuffling deck by randomly going through a for loop,
{						   //assigning every Nth element to a random spot
	for(int c = 0; c < deck.size(); c++)
	{
		int u = dist(gen);
		Card temp = deck[u];
		deck[u] = deck[c];
		deck[c] = temp;
	}
}

Card DeckOfCards::dealCard()//a function that returns the last element of the vector
{							//and removes it from the vector if there're more than
	if(moreCards())			//zero elements
	{
		Card temp = deck[deck.size()-1];
		deck.pop_back();
		return temp;
	}
	else//I'll admit, wasn't exactly sure what to do here
	{	//just returns some fake-ass card
		return Card(0,0);
	}
}

bool DeckOfCards::moreCards()
{
	return deck.size() > 0;
}