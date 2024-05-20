/** Reemplazar por la solución del enunciado */
class Personaje{
	var property estrategia
	var property espiritualidad
	var property poderes = #{}
	method capBatalla() = poderes.fold(0, { acum, poder => acum + poder.capBatalla(self)})
	
	method afrontarPeligro(peligro){
		if(peligro.esEnfrentablePor(self)){
			estrategia += peligro.complejidad()
		}
	}
	
	method inmuneRadioactivo(){
		return poderes.any({n => n.otorgaInmunidad()})
	}
	
	method mejorPoder(){
		return poderes.max({n => n.capBatalla(self)})
	}
	
}

class Poder{
	var property agilidad = 0
	var property fuerza = 0
	var property habEspecial = 0
	method capBatalla(usuario) = (self.agilidad(usuario) + self.fuerza(usuario)) * self.habEspecial(usuario)
	method otorgaInmunidad()
}

class Velocidad inherits Poder{
	var property rapidez
	
	override method agilidad(usuario) = usuario.estrategia() * rapidez
	override method fuerza(usuario) = usuario.espiritualidad() * rapidez
	override method habEspecial(usuario) = usuario.estrategia() + usuario.espiritualidad()
	override method otorgaInmunidad() = false
}

class Vuelo inherits Poder{
	var property alturaMax
	var property energiaDespegue
	
	override method agilidad(usuario) = (usuario.estrategia() * alturaMax).div(energiaDespegue)
	override method fuerza(usuario) = usuario.espiritualidad() + alturaMax - energiaDespegue
	override method habEspecial(usuario) = usuario.estrategia() + usuario.espiritualidad()
	override method otorgaInmunidad() = alturaMax > 200
}

class Amplificador inherits Poder{
	var property poderBase
	var property numAmplificador
	
	override method agilidad(usuario) = poderBase.agilidad(usuario)
	override method fuerza(usuario) = poderBase.fuerza(usuario)
	override method habEspecial(usuario) = poderBase.habEspecial(usuario) * numAmplificador
	override method otorgaInmunidad() = true
	
}

class Equipo{
	var property integrantes = #{}
	
	method masVulnerable(){
		return integrantes.min({n => n.capBatalla()})
	}
	
	method calidad(){
		return integrantes.sum({n => n.capBatalla()}).div(integrantes.size())
	}
	
	method mejoresPoderes(){
		return integrantes.map({n => n.mejorPoder()}).asSet()
	}
	
	method afrontarPeligro(peligro){
		if(integrantes.filter({n => peligro.esEnfrentablePor(n)}).size() > peligro.maxPersonajes()){
			integrantes.filter({n => peligro.esEnfrentablePor(n)}).forEach({n => n.afrontarPeligro(peligro)})
		}
	}
}

class Peligro{
	var property capBatalla
	var property esRadioactivo
	var property complejidad
	var property maxPersonajes
	
	method esEnfrentablePor(personaje){
		if(esRadioactivo){
			return personaje.inmuneRadioactivo() and personaje.capBatalla() > capBatalla
		}
		return personaje.capBatalla() > capBatalla
	}
	
	method esSensato(equipo){
		return equipo.integrantes().all({n => self.esEnfrentablePor(n)})
	}
	
}

class Metahumano inherits Personaje{
	override method capBatalla() = super() * 2
	override method inmuneRadioactivo() = true
	
	override method afrontarPeligro(peligro){
		if(peligro.esEnfrentablePor(self)){
			estrategia += peligro.complejidad()
			espiritualidad += peligro.complejidad()
		}
	}
	
}

class Mago inherits Metahumano{
	var property poderAcumulado
	override method capBatalla() = super() + poderAcumulado
	
	override method afrontarPeligro(peligro){
		if(poderAcumulado > 10){super(peligro)}
		poderAcumulado = (poderAcumulado-5).max(0)
	}
}