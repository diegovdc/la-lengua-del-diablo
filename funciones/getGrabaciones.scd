(// ~getGrabaciones
var getBufferDuration = {|buffer|
	buffer.numFrames/buffer.sampleRate
};
~getGrabaciones = {|currentPath, carpeta|
	SoundFile
	.collectIntoBuffers(currentPath++"/"++carpeta++"/*", s)
	.collect({|buff| (buffer: buff, dur: getBufferDuration.(buff))})
};
)