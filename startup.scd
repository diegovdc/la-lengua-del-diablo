//
("Archivo de inicialización ejecutándose en" + (Platform.userConfigDir +/+ "startup.scd")).postln; // para cuando alguien más quiera saber porque al abrir SC corre la "Lengua del diablo"

// agregar aquí el path a la-lengua-del-diablo... Para obtenerla se puede evaluar ~currentPath después de correr la-lengua-del-diablo/init.scd
"path/to/la-lengua-del-diablo/init.scd".load;
