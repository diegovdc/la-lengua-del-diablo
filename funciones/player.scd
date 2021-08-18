(// ~player
var prettyEventTypes = (
	composiciones: 'composición',
	paisajes: 'paisaje sonoro',
	entrevistas: 'entrevista'
);

~player = {|secuencia|
	Task({
		5.wait;
		secuencia.do({|event|
			var wait_ = event.dur+event.silencio;
			var buffer = Synth(\buffer, [\bufnum, event.buffer]);
			("Reproduciendo" + prettyEventTypes[event.type] ++ ":" + PathName(event.buffer.path).fileName).postln;
			("El siguiente evento dura" + (event.dur).asInt + "segundos.").postln;
			("Habrá" + event.silencio + "segundos de silencio.").postln;
			"\n\n".postln;
			wait_.wait;
		})
	});
};
)