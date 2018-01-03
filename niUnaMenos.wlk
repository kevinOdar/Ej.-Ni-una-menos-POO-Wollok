class Agresiones
{
	var palabrasInaceptables
	var palabrasUtilizadas
	var lugar
	var personaQueLaEfectuo
	constructor(_lugar, _personaQueLaEfectuo, _palabrasUtilizadas)
	{ 
		palabrasUtilizadas = _palabrasUtilizadas
		lugar = _lugar
		personaQueLaEfectuo = _personaQueLaEfectuo
	}
	
	method utilizoPalabraInaceptable() = palabrasUtilizadas.any({palabraDicha => palabrasInaceptables.contains(palabraDicha)})
	method esGrave() = self.utilizoPalabraInaceptable()
	method esIgnea() = palabrasUtilizadas.contains("fuego")
	method personaQueLaEfectuo() = personaQueLaEfectuo
}

class AgresionFisica inherits Agresiones
{
	var elementoUtilizado
	constructor(_lugar, _personaQueLaEfectuo, _palabrasUtilizadas, _elementoUtilizado) = super(_lugar, _personaQueLaEfectuo, _palabrasUtilizadas)
	{ elementoUtilizado = _elementoUtilizado}
	override method esGrave() = true
	override method esIgnea() = elementoUtilizado == "combustible" || super()

}

class Persona
{
	var agresionRecibida //la más reciente
	var composicionFamiliar
	var actitudFrenteALaVida
	var historialDeAgresiones // anteriores a agresionRecibida
	constructor(_agresionRecibida, _composicionFamiliar, _actitudFrenteALaVida, _historialDeAgresiones)
	{	
		agresionRecibida = _agresionRecibida 			composicionFamiliar=_composicionFamiliar
		actitudFrenteALaVida = _actitudFrenteALaVida 	historialDeAgresiones = _historialDeAgresiones
	}
	method hacerLaDenuncia() = self.cumplePrimerReq() && self.cumpleSegundoReq() && self.cumpleTercerReq()
	method cumplePrimerReq() = agresionRecibida.esGrave()
	method cumpleSegundoReq() = self.poseeVinculoFamiliar(agresionRecibida.personaQueLaEfectuo())
	method poseeVinculoFamiliar(posibleFamiliar) = composicionFamiliar.contains(posibleFamiliar)
	method cumpleTercerReq() = actitudFrenteALaVida.puedeDenunciar(self)
	
	method historialDeAgresiones() = historialDeAgresiones
	method agresionRecibida() = agresionRecibida
	method composicionFamiliar() = composicionFamiliar
	
	//Parte 3
	method participarEnONG(){	actitudFrenteALaVida = actitudMilitante	}
	method recibirAcompaniamiento(acompaniante){	actitudFrenteALaVida = acompaniante.actitudFrenteALaVida()	}
	method recibirAmenazaDeMuerte() {	actitudFrenteALaVida = actitudFrenteALaVida.recibirAmenazaDeMuerte()	} 

}

object actitudMiedo
{
	method puedeDenunciar(_) = false 
	method recibirAmenazaDeMuerte() = self 
}

class ActitudPaciente
{
	var umbralDeTolerancia
	constructor(_umbralDeTolerancia) {umbralDeTolerancia=_umbralDeTolerancia}
	method puedeDenunciar(victima)
	{
		return victima.historialDeAgresiones().count({agresion => agresion.personaQueLaEfectuo() == victima.agresionRecibida().personaQueLaEfectuo()}) > umbralDeTolerancia 
	}
	method recibirAmenazaDeMuerte() = new ActitudPaciente(umbralDeTolerancia*=2)

}

object actitudAguerrida
{
	method puedeDenunciar(victima) = victima.historialDeAgresiones().any({agresion => agresion.esGrave() && victima.poseeVinculoFamiliar(agresion.personaQueLaEfectuo())})
	method recibirAmenazaDeMuerte() = new ActitudPaciente(5)

}

object actitudMilitante
{
	method puedeDenunciar(_) = true
	method recibirAmenazaDeMuerte() = actitudAguerrida
}


