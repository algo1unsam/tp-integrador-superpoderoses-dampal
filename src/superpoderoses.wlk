/** Reemplazar por la solución del enunciado */
class Personaje{
	var property estrategia
	var property espiritualidad
	var property poderes = #{}
	method capBatalla() = poderes.map({n => n.capBatalla()}).sum()
	
	method afrontarPeligro(peligro){
		if(peligro.esEnfrentablePor(self)){
			estrategia += peligro.complejidad()
		}
	}
	
	method inmuneRadioactivo(){
		return poderes.any({n => n.otorgaInmunidad()})
	}
	
}

class Poder{
	var property agilidad = 0
	var property fuerza = 0
	var property habEspecial = 0
	method capBatalla() = (agilidad + fuerza) * habEspecial
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
		return integrantes.sum({n => n.capBatalla()})/integrantes.len()
	}
	
	method mejoresPoderes(){
		return integrantes.map({n => n.poderes()}).foreach({n => n.max({m => m.capBatalla()})}).flatten()
	}
	
	method afrontarPeligro(peligro){
		if(integrantes.filter({n => peligro.esEnfrentablePor(n)}).len() < peligro.maxPersonajes()){
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
	override method capBatalla() = 2 * poderes.map({n => n.capBatalla()}).sum()
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
	override method capBatalla() = 2 * poderes.map({n => n.capBatalla()}).sum() + poderAcumulado
	
	override method afrontarPeligro(peligro){
		if(peligro.esEnfrentablePor(self)){
			estrategia += peligro.complejidad()
			espiritualidad += peligro.complejidad()
		}
		poderAcumulado = (poderAcumulado-5).max(0)
	}
}