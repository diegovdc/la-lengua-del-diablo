(
('Iniciando servidor').postln;
s.boot;
s.doWhenBooted({
	var tresHoras = 60*60*3;
	var dosHoras = 60*60*2;
	var sieteHoras = 60*60*7;

	var makeSequence = {}, sequence = []; //ver abajo

	SynthDef(\buffer, {|bufnum, numchanel = 2, rate = 1|
		var sig, out;
		sig = PlayBuf.ar(2, bufnum, rate, loop:0, doneAction:2);
		out = Out.ar(0, sig)
	}).send(s);

	[// load files
		"getSilence.scd", // importa ~getSilenceFromBlocks
		"getNextSoundType.scd",
		"lazy-player.scd",
	].do({|file|
		(~currentPath++"/funciones/"++file).load
	});

	~lazyPlayer.(
		~getNextSoundType,
		~getSilenceFromBlocks.(
			[(5..30),   (15..15*60), (5*60..30*60)],
			  tresHoras, dosHoras,    tresHoras,
		)
	).play;


	3.do({("\n").postln});
	(
		"========================================\n\n"++
		'     Iniciando "La Lengua del Diablo"'++
		"\n\n========================================\n\n"
	).postln;

});
('Servidor iniciado'++"\n\n")
)
