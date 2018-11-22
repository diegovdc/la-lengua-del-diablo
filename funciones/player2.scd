
(// ~player2
var sieteHoras = 60*60*7;

var getPaths = {|carpeta|
   PathName(~currentPath++'/audios/'++carpeta)
	.files
	.collect(_.fullPath)
};

~player2 = {|getNextSoundType, getSilence|
	var prettyEventTypes = (
		composiciones: 'composición',
		paisajes: 'paisaje sonoro',
		entrevistas: 'entrevista'
	);

	var entrevistas = getPaths.("entrevistas").scramble;

	var composiciones = getPaths.("composiciones").scramble;

	var paisajes = getPaths.("paisajes").scramble;

	var sonidos = (entrevistas: entrevistas, composiciones: composiciones, paisajes: paisajes);

	var playerState = (
		duracion: 0, // Number -- duración acumulada
		indexes: (entrevistas: -1, composiciones: -1, paisajes: -1), //(sonido: índice)
	);
	var getBufferDuration = {|buffer|
		buffer.numFrames/buffer.sampleRate
	};
	var nextWait = 5;
	var buffers  = List [];
	var task = Task({
		inf.do({|index|
			var soundType = getNextSoundType.(index);
			var soundIndex = playerState.indexes[soundType]+1;
			var sonidoPath = sonidos[soundType].wrapAt(soundIndex);
			var silencio =  getSilence.(playerState.duracion);
			var indexes = playerState.indexes;

			var buffer = Buffer.read(s, sonidoPath, action: {
				var duration = getBufferDuration.(buffer);
				var wait_ = duration + silencio;

				if(playerState.duracion < sieteHoras, {
					Synth(\buffer, [\bufnum, buffer]);
					playerState = (
						duracion: playerState.duracion + wait_,
						indexes: indexes
					);

					buffers.add(buffer);//agregamos el buffer a la lista, para liberarlo después de nextWait.wait

					nextWait = wait_;

					("Reproduciendo" + prettyEventTypes[soundType] ++ ":" + PathName(buffer.path).fileName).postln;
					("El siguiente evento dura" + (duration).asInt + "segundos.").postln;
					("Habrá" + silencio + "segundos de silencio.").postln;
					"\n\n".postln;
				},
				{
					(
						"========================================\n\n"++
						'"La Lengua del Diablo" ha terminado'++
						"\n\n========================================\n\n"
					).postln;
					task.stop;
				});


			});

			if(index==0, {5.wait}); //previene que el Task loopée antes de que el action de Buffer.read se ejecute
			nextWait.wait;

			buffers[index].free; // liberamos el buffer que se acaba de usar

/*			if(playerState.duracion > sieteHoras, {
				'"La Lengua del Diablo" ha terminado'.postln;
				task.stop;
			})*/
		})

	});

	task;
};
)
