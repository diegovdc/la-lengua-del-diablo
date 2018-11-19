(//~getSilence
// var silences = (5..(30*60));
var silences = (5..10);
var midpoint = (silences.normalizeSum.size/3*2).asInteger;
var firstPart = silences[0..midpoint]; //primera parte de la curva de ponderancia
var weights = (firstPart.mirror)[0..silences.size - 1].normalizeSum;
~getSilence = {silences.wchoose(weights);}
)