(
('Iniciando servidor').postln;
s.boot;
s.doWhenBooted({

	SynthDef(\buffer, {|bufnum, numchanel = 2, rate = 1|
		var sig, out;
		sig = PlayBuf.ar(2, bufnum, rate, loop:0, doneAction:2);
		out = Out.ar(0, sig)
	}).send(s);

	[// load files
		"getSilence.scd",
		"getNextSoundType.scd",
		"getGrabaciones.scd",
		"makeSequence.scd",
		"player.scd",
	].do({|file|
		(~currentPath++"/funciones/"++file).load
	});

	~player.(
		~makeSequence.(
			~getGrabaciones.(~currentPath, _),
			~getNextSoundType,
			~getSilence

		)
	).play;

	(
		"\n\n\n\n\n\n========================================\n\n"++
		'Iniciando "La Lengua del Diablo"'++
		"\n\n========================================\n\n"
	).postln;

});

('Servidor iniciado'++"\n\n")
)