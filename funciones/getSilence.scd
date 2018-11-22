(//~getSilence
// var silences = (5..(30*60));
~getSilence = {|silenceRange|
	var midpoint = (silenceRange.normalizeSum.size/3*2).asInteger;
	var firstPart = silenceRange[0..midpoint]; //primera parte de la curva de ponderancia
	var weights = (firstPart.mirror)[0..silenceRange.size - 1].normalizeSum;
	{silenceRange.wchoose(weights)};
};

// ~getSilenceFromBlocks :: ([[Number]] , Number, Number, Number) -> Number -> Number
~getSilenceFromBlocks = {|ranges_array, block1, block2, block3|
	var getSilences = ranges_array.collect(~getSilence);
	{|duration|
		case
		{duration < block1}                      {getSilences[0].()}
		{duration < (block1 + block2)}           {getSilences[1].()}
		{duration < (block1 + block2 + block3)}  {getSilences[2].()}
		{true}                                   {getSilences[1].()};
	}

};
)

