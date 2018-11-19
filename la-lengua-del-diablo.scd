(
s.boot;
~currentPath = thisProcess.nowExecutingPath.dirname;
)


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
// ~getNextEvent.(0)

(//~getSilence
// var silences = (5..(30*60));
var silences = (5..10);
var midpoint = (silences.normalizeSum.size/3*2).asInteger;
var firstPart = silences[0..midpoint]; //primera parte de la curva de ponderancia
var weights = (firstPart.mirror)[0..silences.size - 1].normalizeSum.postln;
~getSilence = {silences.wchoose(weights);}
)

// ~getSilence.()
Buffer

(// ~getGrabaciones
var numFramesToDur = {|buffer|
	"[numFramesToDur] Esta función debe convertir numframes a duración en segundos".postln;
	buffer.numFrames/(buffer.sampleRate/buffer.numFrames)
};
~getGrabaciones = {|carpeta|
	SoundFile
	.collectIntoBuffers(~currentPath++"/"++carpeta++"/*", s)
	.collect({|buff| (sonido: buff, dur: numFramesToDur.(buff))})
};

)
// ~getGrabaciones.("paisajes");

(// ~secuencia
var entrevistas = ~getGrabaciones.("paisajes").scramble;

var composiciones = ~getGrabaciones.("paisajes").scramble;

var paisajes = ~getGrabaciones.("paisajes").scramble;

var sonidos = (entrevistas: entrevistas, composiciones: composiciones, paisajes: paisajes);

~secuencia = (0..5000).inject(
	(
		secuencia: List [], // (sonido: Buffer, silencio: Number)
		duracion: 0, // Number -- duración acumulada
		indexes: (entrevistas: -1, composiciones: -1, paisajes: -1), //(sonido: índice)
	),
	{|acc, index|
		// if(acc.duracion > 7horas, {acc}, {corremos todo lo que sigue})
		var soundType = ~getNextSoundType.(index);
		var soundIndex = acc.indexes[soundType]+1;
		var sonido = sonidos[soundType].wrapAt(soundIndex);
		var silencio =  ~getSilence.();
		var indexes = acc.indexes;
		indexes[soundType] = soundIndex;
		(
			secuencia: acc.secuencia.add((buffer: sonido.buffer, dur: sonido.dur,  silencio: silencio, type: soundType)),
			duracion: acc.duracion + sonido.dur + silencio,
			indexes: indexes
		)
	}
).secuencia


)

(
Task({
	~secuencia.do({|event|
		var wait_ = event.dur+event.silencio;
		// event.postln;
		Synth(\buffer, [\bufnum, event.buffer]);
		("El siguiente sonido dura" + event.dur + "segundos").postln;
		("Habrá" + event.silencio + "segundos de silencio").postln;
		wait_.wait;
		// 2.wait; // debería de usarse el código de arriba, pero de momento usamos este para probar
	})
}).play
)

s.boot


(// ~getGrabaciones
var getBufferDuration = {|buffer|
	buffer.numFrames/buffer.sampleRate
};
~getGrabaciones = {|carpeta|
	SoundFile
	.collectIntoBuffers(~currentPath++"/"++carpeta++"/*", s)
	.collect({|buff| (buffer: buff, dur: getBufferDuration.(buff))})
};
~getGrabaciones.('paisajes')[1].buffer.path.postln;
~getGrabaciones.('paisajes')[1].dur
)




(
SynthDef(\buffer, {|bufnum, numchanel = 2, rate = 1|
	var sig, out;
	sig = PlayBuf.ar(2, bufnum, rate, loop:0, doneAction:2);
	out = Out.ar(0, sig)
}).send(s);
)

a = Synth(\buffer, [\bufnum, ~getGrabaciones.('paisajes')[1].buffer]);
a.free;
