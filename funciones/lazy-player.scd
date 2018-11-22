
(// ~player2
var sieteHoras = 60*60*7;

var getPaths = {|carpeta|
   PathName(~currentPath++'/audios/'++carpeta)
	.files
	.collect(_.fullPath)
};

~lazyPlayer = {|getNextSoundType, getSilence|
	var prettyEventTypes = (
		composiciones: 'composición',
		paisajes: 'paisaje sonoro',
		entrevistas: 'entrevista'
	);

	var entrevistas = getPaths.("entrevistas").scramble;

	var composiciones = getPaths.("composiciones").scramble;

	var paisajes = getPaths.("paisajes").scramble;

	var sonidos = (entrevistas: entrevistas, composiciones: composiciones, paisajes: paisajes);

	var getBufferDuration = {|buffer|
		buffer.numFrames/buffer.sampleRate
	};

	// estado del task
	var nextWait = 5;
	var buffers  = List [];
	var playerState = (
		duracion: 0, // Number -- duración acumulada
		indexes: (entrevistas: -1, composiciones: -1, paisajes: -1), //(sonido: índice)
	);

	var task = Task({
		inf.do({|index|
			var soundType = getNextSoundType.(index);
			var soundIndex = playerState.indexes[soundType]+1;
			var sonidoPath = sonidos[soundType].wrapAt(soundIndex);
			var silencio =  getSilence.(playerState.duracion);

			var buffer = Buffer.read(s, sonidoPath, action: {
				var duration = getBufferDuration.(buffer);
				var wait_ = duration + silencio;
				var indexes = playerState.indexes;
				indexes[soundType] = indexes[soundType] + 1;

				if(playerState.duracion < sieteHoras, {
					Synth(\buffer, [\bufnum, buffer]);

					playerState = (
						duracion: playerState.duracion + wait_,
						indexes: indexes
					);

					buffers.add(buffer);//agregamos el buffer a la lista, para liberarlo después de nextWait.wait

					nextWait = wait_;

					//notificaciones
					("Reproduciendo" +
						prettyEventTypes[soundType] ++
						":" +
						PathName(buffer.path).fileName).postln;

					("El siguiente evento dura" +
						(duration).asInt + "segundos.").postln;

					("Habrá" +
						(silencio + 1 /*ver 1.wait más abajo*/) +
						"segundos de silencio.").postln;

					"\n\n".postln;
				},
				{
					//notificaciones
					(
						"========================================\n\n"++
						'     "La Lengua del Diablo" ha terminado'++
						"\n\n========================================\n\n"
					).postln;
					task.stop;
				});


			});
			1.wait;//previene que el Task loopée antes de que el action de Buffer.read se ejecute

			// ("nextWait:"+(nextWait+1)).postln;
			nextWait.wait;

			buffers[index].free; // liberamos el buffer que se acaba de usar

		})

	});

	task;
};
)
