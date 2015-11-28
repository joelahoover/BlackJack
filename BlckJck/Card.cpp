//Card.cpp in Blackjack

#include <string>
#include "Card.h"

const static std::string faces[] = { "Ace", "Two","Three","Four","Five","Six","Seven", "Eight", "Nine", "Ten", "Jack","Queen","King" };
static const std::string suits[] = { "Fox", "Elephant", "Giraffe", "Monkey" };


Card::Card(int inFace, int inSuit)
{
	face = inFace;
	suit = inSuit;
}

std::string Card::to_string() const
{
	return faces[face] + std::string(suits[suit]);
}