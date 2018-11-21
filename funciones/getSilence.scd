(//~getSilence
// var silences = (5..(30*60));
~getSilence = {|silenceRange|
	var midpoint = (silenceRange.normalizeSum.size/3*2).asInteger;
	var firstPart = silenceRange[0..midpoint]; //primera parte de la curva de ponderancia
	var weights = (firstPart.mirror)[0..silenceRange.size - 1].normalizeSum;

	{silenceRange.wchoose(weights)};
}
)