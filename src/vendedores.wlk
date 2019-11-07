class CentroDeDistribucion{
	const property vendedores =[]
	var property ciudadDondeEstaUbicado 
	
	method agregarVendedor(unVendedor){
		if (vendedores.contains(unVendedor)){
			self.error("Ya está registrado")
		}
		else vendedores.add(unVendedor)
	}
	method vendedorEstrella(){
		return vendedores.max({vendedor => vendedor.puntajeTotalPorCertificaciones()})
	}
	method puedeCubrirCiudad(unaCiudad){
		return vendedores.count({vendedor => vendedor.puedeTrabajarEn_(unaCiudad)})
	}
	method coleccionDeVendedoresGenericos(){
		return vendedores.filter({vendedor => vendedor.esGenerico()})
	}
	method vendedoresFirmes(){ return vendedores.filter({vendedor => vendedor.esFirme()})}
	method esRobusto(){
		return self.vendedoresFirmes().size() >= 3
	}
	
/*Debe poder consultarse, para un centro de distribución:

el vendedor estrella, que es el que tiene mayor puntaje total por certificaciones.
si puede cubrir, o no, una ciudad dada. La condición es que al menos uno de los vendedores registrados 
pueda trabajar en esa ciudad.
la colección de vendedores genéricos registrados. 
Un vendedor se considera genérico si tiene al menos una certificación que no es de productos.
si es robusto, la condición es que al menos 3 de sus vendedores registrados sea firme.*/
	
}


class Vendedor {
	const property certificaciones = []
	
	method puntajeTotalPorCertificaciones(){
		return certificaciones.sum({certificacion => certificacion.puntos()})
	}
	
	method esVersatil(){
		//que tenga al menos tres certificaciones, que tenga al menos una sobre productos, 
		// y al menos una que no sea sobre productos.
		return certificaciones.size() >= 3 and
			   certificaciones.any({cert => cert.sobreProductos()}) and
			   certificaciones.any({cert => not cert.sobreProductos()})
	}
	
	method esFirme(){
		return self.puntajeTotalPorCertificaciones() >= 30
	}
	method esGenerico(){
		return certificaciones.any({cert => not cert.sobreProductos()})
	}
	
	method puedeTrabajarEn_(ciudad)
	method esInfluyente()
	
}
/*vendedor fijo: ningún vendedor fijo es influyente.
viajante: la población total sumando todas las provincias donde está habilitado, debe ser de 10 millones o superior.
comercio corresponsal: debe tener sucursales en al menos 5 ciudades,
*  o bien en al menos 3 provincias considerando la provincia de cada ciudad donde tiene sucursal. */

class VendedorFijo inherits Vendedor{
	var property ciudad = ""
	
	override method puedeTrabajarEn_(unaCiudad){
		return self.ciudad() == unaCiudad
	}
	override method esInfluyente() = false
}

class Viajante inherits Vendedor {
	const property provinciasHabilitado = []
	//var property  ciudadesDondePuedeTrabajar = provinciasHabilitado.map({pcia => pcia.ciudades()})
	
	//falta terminar
	override method puedeTrabajarEn_(unaCiudad){
		return provinciasHabilitado.contains({})
	}
	method sumaDePoblacionDeLasProvinciasHabilitado(){
		return self.provinciasHabilitado().sum({provincia => provincia.poblacion()})
	}
	override method esInfluyente(){
		return self.sumaDePoblacionDeLasProvinciasHabilitado() >= 10000000
	}
}

class ComercioCorresponsal inherits Vendedor{
	const property sucursalesEnCiudad = []
	
	override method puedeTrabajarEn_(unaCiudad){
		return sucursalesEnCiudad.contains(unaCiudad)
	}
	override method esInfluyente(){ 
		//debe tener sucursales en al menos 5 ciudades,
		//  o bien en al menos 3 provincias considerando la provincia de cada ciudad donde tiene sucursal.
		return sucursalesEnCiudad.size() >= 5 or 
			   
			   
	}
}

class Ciudad {
	const property nombre = ""
	const property provincia  
	
}

class Provincia{
	var property poblacion 
	var property ciudades = []
}

class Certificacion{
	var property puntos = 0
	var property sobreProductos = true
}

/*dada una ciudad, si un vendedor puede trabajar en esa ciudad. 
 * La condición depende del tipo de vendedor, como se indica a continuación
vendedor fijo: debe ser la ciudad en la que vive.
viajante: la ciudad debe estar en una provincia en la que está habilitado.
comercio corresponsal: debe ser una ciudad en la que tiene sucursal.
si un vendedor es versátil. Las condiciones son: 
* que tenga al menos tres certificaciones, que tenga al menos una sobre productos, 
* y al menos una que no sea sobre productos.
*/

/*Vendedor fijo: se sabe en qué ciudad vive.
Viajante: cada viajante está habilitado para trabajar en algunas provincias, se sabe cuáles son.
Comercio corresponsal: son comercios que tienen sucursales en distintas ciudades.
*  Se sabe, para cada comercio corresponsal, en qué ciudades tiene sucursales.
De cada ciudad debemos registrar en qué provincia está, y de cada provincia, la población.

De cada vendedor, se tiene detalle de las certificaciones que posee. 
* Cada certificación otorga una cantidad de puntos. 
* Algunas certificaciones son sobre productos, otras no. */