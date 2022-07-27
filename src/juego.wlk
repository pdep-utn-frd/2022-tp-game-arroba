import wollok.game.*
import consola.*
//objeto direccion
// herencia 
// items juego

class Juego {
	var property position = null
	var property color 
	
	method image()= "icono juego.png"
	method text()="Snake Game"
	
	method iniciar(){
			
        game.addVisual(fondo)
        game.addVisualCharacter(cara)
        game.addVisual(gusanoVerde)
        game.addVisual(gusanoRojo1)
        game.addVisual(gusanoRojo2)
        game.addVisual(gusanoRojo3)
        game.addVisual(gusanoRojo4)
        game.addVisual(gusanoRojo5)
        game.addVisual(gusanoRojo6)
        game.addVisual(gusanoRojo7)
        game.addVisual(gusanoRojo8)
        game.addVisual(gusanoRojo9)
        game.addVisual(puntos)
        cara.iniciar() 
        const musica = game.sound("fondoo.mp3")
	musica.shouldLoop(true)
	game.schedule(100, { musica.play()} )
     }
        
	
	method terminar(){
		game.stop()
	}
	
	
}

object fondo{
	method position() = game.at(-1,-1)
	method image() = "fondo.jpg"
}

class Direccion {
	 method x()=1
	 method y()=0
}

const derecha = new Direccion()
object izquierda inherits Direccion{
	override method x()=-1
	override method y()=0
}
object arriba inherits Direccion{
	override method x()=0
	override method y()=1
}
object abajo inherits Direccion{
	override method x()=0
	override method y()=-1
}

object cara{
	
	const cuerpo = new Cuerpo()
	var property position = game.at(0,7)
	var property ultimo = "derecha"
	var imagen = "cara1.png"
	var posicionPrevia
	var property direccionActual = derecha
	var proximaImagen ="cara1.png"
//	var property ultimaDireccion = [1,0]
	
	method position() = position
	method image() = imagen
	method iniciar(){
		game.schedule(200, {game.addVisual(cuerpo)})
		game.onTick(200,"moverSerpiente", {self.mover()})
		
		keyboard.right().onPressDo({ 
//			ultimaDireccion= direccionActual
			direccionActual=derecha
			proximaImagen="cara1.png"
		})
		
		keyboard.up().onPressDo{
//			ultimaDireccion= direccionActual
			direccionActual=arriba
			proximaImagen="cara4.png"
		}
		
		keyboard.down().onPressDo{ 
//			ultimaDireccion= direccionActual
			direccionActual=abajo
			proximaImagen="cara2.png"
		}
		
		keyboard.left().onPressDo{ 
//			ultimaDireccion= direccionActual
			direccionActual=izquierda
			proximaImagen="cara3.png"
		}
				
		self.chocar()
}
		
	method mover(){
		posicionPrevia=position
		position = game.at(position.x()+ direccionActual.x(), position.y()+direccionActual.y())
		cuerpo.mover(posicionPrevia)	
		imagen=proximaImagen	
		if (position.x() == 17){
			position = game.at(0,position.y())}
		if (position.y() == 12){
		 position = game.at(position.x(),0)}
		 if (position.y() == -1){
		position = game.at(position.x(),12)
		 }
		 if (position.x() == -1){
			position = game.at(17,position.y())
		 }
	}	
	
	method previousPosition()=posicionPrevia
	
	method aumentarTamanio(){
		cuerpo.aumentarTamanio()
	}
	
	method detener(){
		game.removeVisual(self)
		game.removeTickEvent("moverSerpiente")
		
	}
	
	method hablar() = "yummy"
	
	method chocar(){
	// Apenas el personaje wollok colisione con la caja, el personaje habla y la caja se desplaza
  		game.whenCollideDo(self, { elemento => 
    		elemento.manejarChoque()
    		})
	}
} 


class Gusano{
	var property position = game.at(6,6)
	
	method position() = position
	method image() = "gusanoo.png"
	
	method cambioPosicion(){
		const x = 0.randomUpTo(game.width()).truncate(0)
    	const y = 0.randomUpTo(game.height()).truncate(0)
    	position = game.at(x,y) 
	}	
	method reaccion(){
		game.say(cara, cara.hablar())
		game.sound("comegusano.wav").play()
		cara.aumentarTamanio()
	}
	method calculoDePuntos(){
		puntos.suma()
	}
 	
 	method manejarChoque() {
    	self.cambioPosicion()
    // otra forma de generar números aleatorios
    // const x = (0.. game.width()-1).anyOne() 
    // const y = (0.. game.height()-1).anyOne() 
    	self.reaccion()
    	self.calculoDePuntos()
  	}
}
const gusanoVerde = new Gusano()
class GusanoRojo inherits Gusano(position = game.at(3,4)){
	override method calculoDePuntos(){
		puntos.resta()
	}
	override method image()= "gusanorojo4.png"
}
const gusanoRojo1 = new GusanoRojo (position = game.at(3,4))
const gusanoRojo2 = new GusanoRojo (position = game.at(1,4))
const gusanoRojo3 = new GusanoRojo (position = game.at(9,4))
const gusanoRojo4 = new GusanoRojo (position = game.at(3,6))
const gusanoRojo5 = new GusanoRojo (position = game.at(7,8))
const gusanoRojo6 = new GusanoRojo (position = game.at(14,6))
const gusanoRojo7 = new GusanoRojo (position = game.at(2,9))
const gusanoRojo8 = new GusanoRojo (position = game.at(2,1))
const gusanoRojo9 = new GusanoRojo (position = game.at(13,8))


object puntos{
	const property verde = "00FF00FF"
	var puntos = 0
	method text() = puntos.toString()
	method textColor() = verde
	method position() = game.at(1,10)
	method suma(){
		puntos += 150
	} 
	method resta(){
		puntos -= 100
	}
	method manejarChoque(){
	}
	
}


class Cuerpo{
	var behind = null
	var property position = game.at(1,7)
	const imagen = "cuadrado1.png"
	var posicionPrevia = null

	method image() = imagen
	
	method mover(siguientePosicion){
		posicionPrevia=position
		position = siguientePosicion
		if (behind!=null){
			behind.mover(posicionPrevia)			
		}
		}
		
	method manejarChoque(){
//		if (
//			(cara.ultimaDireccion==[0,1] and cara.direccionActual==[0,-1])
//		){}
//		else{
//prevenir que se pierda cuando se pasa de una direccion a la opuesta 
		cara.detener()
		game.addVisual(gameOver)
		game.sound("fin.wav").play()
		}
		
	
	method aumentarTamanio(){
		if (behind==null){
			behind = new Cuerpo( position= posicionPrevia)
			game.addVisual(behind)
		}
		else
		behind.aumentarTamanio()
	}
} 

object gameOver{
	var imagen="gameover1.png"
	var property position= game.at(2,2)
	
	method image()=imagen
}


