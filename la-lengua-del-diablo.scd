(
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

(
var silences = (5..(30*60));
var midpoint = (silences.normalizeSum.size/3*2).asInteger;
var firstPart = silences[0..midpoint]; //primera parte de la curva de ponderancia
var weights = (firstPart.mirror)[0..silences.size].normalizeSum.postln; //el bug lo produce la suma normalizada
~getSilence = {silences.wchoose(weights);}
)

// ~getSilence.()


(
var entrevistas = [
	(buffer: 'Un enterevista', dur: 50),
	(buffer: 'enterevista2', dur: 80)
];

var composiciones = [
	(buffer: 'Un compo', dur: 50),
	(buffer: 'Un compo2', dur: 80)
];

var paisajes = [
	(buffer: 'Un paisaje', dur: 50),
	(buffer: 'Un paisaje2', dur: 80)
];
var sonidos = (entrevistas: entrevistas, composiciones: composiciones, paisajes: paisajes);

(0..50).inject(
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
			secuencia: acc.secuencia.add((sonido: sonido, silencio: silencio)),
			duracion: acc.duracion + sonido.dur + silencio,
			indexes: indexes
		)
	}

)


)
