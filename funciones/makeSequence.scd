(// ~makeSequence
~makeSequence = {|getGrabaciones, getNextSoundType, getSilence|
	var entrevistas = getGrabaciones.("paisajes").scramble;

	var composiciones = getGrabaciones.("paisajes").scramble;

	var paisajes = getGrabaciones.("paisajes").scramble;

	var sonidos = (entrevistas: entrevistas, composiciones: composiciones, paisajes: paisajes);

	(0..5000).inject(
		(
			secuencia: List [], // (sonido: Buffer, silencio: Number)
			duracion: 0, // Number -- duración acumulada
			indexes: (entrevistas: -1, composiciones: -1, paisajes: -1), //(sonido: índice)
		),
		{|acc, index|
			// if(acc.duracion > 7horas, {acc}, {corremos todo lo que sigue})
			var soundType = getNextSoundType.(index);
			var soundIndex = acc.indexes[soundType]+1;
			var sonido = sonidos[soundType].wrapAt(soundIndex);
			var silencio =  getSilence.();
			var indexes = acc.indexes;
			indexes[soundType] = soundIndex;
			(
				secuencia: acc.secuencia.add((buffer: sonido.buffer, dur: sonido.dur,  silencio: silencio, type: soundType)),
				duracion: acc.duracion + sonido.dur + silencio,
				indexes: indexes
			)
		}
	).secuencia
};
)
