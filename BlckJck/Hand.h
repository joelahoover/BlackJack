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
	void Hit( Card _input )
	{
		myHand.push_back( _input );
		validateHand();
	}

	void Hold()
	{
		//does nothing
	};



	//helper functions
	void validateHand()
	{
		Blackjack = false;
		bool hasAce11 = false;

		bool isBelow22 = true;
		total = 0;

		for( int n = 0; n < myHand.size(); n++)
		{
			if(myHand[n].face > 9)
				total += 10;

			else if(myHand[n].face == 0)
			{
					if( !hasAce11 && total < 11)
					{
						total += 11;
						hasAce11 = true;
					}
					else
						total += 1;
			}
			else
				total += myHand[n].face + 1;

			if(total > 21 && hasAce11)
			{
				total -= 10;
				hasAce11 = false;
			}

			isBelow22 = total < 22;
		}// end of for loop

		//testing for blackjack
		if( (myHand.size() == 2) && total == 21 )
			Blackjack = true;
	}



	//getters
	int getTotal()
	{
		return total;
	}

	bool hasBlackjack()
	{
		return Blackjack;
    }
    
    std::string to_string()
    {
        std::string out;
        for( unsigned int n = 0; n < myHand.size(); n++)
        {
            out.append(myHand[n].to_string());
            out += '\n';
        }
        
        return out;
    }
};

#endif