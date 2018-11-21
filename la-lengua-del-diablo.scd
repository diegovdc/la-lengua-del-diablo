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
		"getSilence.scd",
		"getNextSoundType.scd",
		"getGrabaciones.scd",
		"makeSequence.scd",
		"player.scd",
	].do({|file|
		(~currentPath++"/funciones/"++file).load
	});

	makeSequence = {|duration, silenceRange|
		~makeSequence.(
			duration,
			~getGrabaciones.(~currentPath, _),
			~getNextSoundType,
			~getSilence.(silenceRange)
		)
	};

	sequence = [
	     makeSequence.(dosHoras, (1..60)),
	     makeSequence.(tresHoras, (15..15*60)),
	     makeSequence.(dosHoras, (5*60..30*60))
	]
	// .scramble // descomentar esta línea si se quiere que estos bloques queden en órdenes distintos con cada compilación
	.flatten;

	~player.(sequence).play;

	50.do({("\n").postln});
	(
		"========================================\n\n"++
		'Iniciando "La Lengua del Diablo"'++
		"\n\n========================================\n\n"
	).postln;

});

('Servidor iniciado'++"\n\n")
)
