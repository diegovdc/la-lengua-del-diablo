(//~getNextSoundType
var c = 'composiciones';
var p = 'paisajes';
var e = 'entrevistas';
var miniSecuencias = [
	[c, p, e],
	[e, e, p],
	[c, e, p],
].scramble.flatten;

~getNextSoundType = {|index|  miniSecuencias.wrapAt(index)};
)
