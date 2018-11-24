(//~getNextSoundType
var c = 'composiciones';
var p = 'paisajes';
var e = 'entrevistas';
var miniSecuencias = [
	[p, e, p],
	[e, e, p],
	[e, p, c],
	[p, p, e],
	[e, p, e],
	[p, e],
	[e, p],
	[p, p, p]
].scramble.flatten;

~getNextSoundType = {|index|  miniSecuencias.wrapAt(index)};
)
