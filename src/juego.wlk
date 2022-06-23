import wollok.game.*
import consola.*

class Juego {
	var property position = null
	var property color 
	
	
	method iniciar(){
        game.addVisual(fondo)
        game.addVisualCharacter(cara)
        game.addVisual(gusano)
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

object cara{
	
	var cuerpo = new Cuerpo()
	var property position = game.at(0,7)
	var property ultimo = "derecha"
	var imagen = "cara.jpeg"
	var posicionPrevia
	var direccionActual = [1,0]
	var proximaImagen ="cara.jpeg"
	
	method position() = position
	method image() = imagen
	method iniciar(){
		game.addVisual(cuerpo)
		game.onTick(300,"moverSerpiente", {self.mover()})
		
		keyboard.right().onPressDo({ 
			direccionActual=[1,0]
			proximaImagen="cara.jpeg"
		})
		
		keyboard.up().onPressDo{
			direccionActual=[0,1]
			proximaImagen="caraarriba.jpeg"
		}
		
		keyboard.down().onPressDo{ 
			direccionActual=[0,-1]
			proximaImagen="caraabajo.jpeg"
		}
		
		keyboard.left().onPressDo{ 
			direccionActual=[-1,0]
			proximaImagen="caraizq.jpg"
		}
			
		self.chocar()
}
		
	method mover(){
		posicionPrevia=position
		position = game.at(position.x()+ direccionActual.get(0), position.y()+direccionActual.get(1))
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
		game.removeVisual(cara)
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


object gusano{
	var property position = game.center()
	
	method position() = position
	method image() = "gusanoo.png"
	
	method iniciar(){
		
	}
	
 	method manejarChoque() {
    	const x = 0.randomUpTo(game.width()).truncate(0)
    	const y = 0.randomUpTo(game.height()).truncate(0)
    // otra forma de generar números aleatorios
    // const x = (0.. game.width()-1).anyOne() 
    // const y = (0.. game.height()-1).anyOne() 
    position = game.at(x,y) 
    game.say(cara, cara.hablar())
    		puntos.calculo()
    game.sound("comegusano.wav").play()
    cara.aumentarTamanio()
  }
}


object paleta {
	const property verde = "00FF00FF"
}
object puntos{
	var puntos = 0
	method text() = puntos.toString()
	method textColor() = paleta.verde()
	method position() = game.at(1,10)
	method calculo(){
		puntos += 132
	} 
	method manejarChoque(){
	}
	
}


class Cuerpo{
	var behind = null
	var property position = game.at(1,7)
	var imagen = "cuadrado1.png"
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
		cara.detener()
		game.addVisual(gameOver)
		game.sound("fin.wav").play()
	}
	
	method aumentarTamanio(){
		console.println("aumento")
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


