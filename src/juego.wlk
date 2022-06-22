import wollok.game.*
import consola.*

class Juego {
	var property position = null
	var property color 
	
	
	method iniciar(){
        game.addVisual(fondo)
        game.addVisualCharacter(cara)
        //game.addVisual(cuadrado)
        game.addVisual(gusano)
        game.addVisual(puntos)
        cara.iniciar()
        
     }
        
	
	method terminar(){
		game.stop()
	}
	
	
}

object fondo{
	method position() = game.at(-1,-1)
	method image() = "fondo.jpg"
}


object cara inherits Cuerpo(  position = game.at(0,7) , ultimo = "derecha", imagen = "cara.jpeg"){
	
	method hablar() = "yummy"
	
	override method chocar(){
	// Apenas el personaje wollok colisione con la caja, el personaje habla y la caja se desplaza
  		game.whenCollideDo(self, { elemento => 
    		elemento.mover()
    		game.say(self, self.hablar())
    		puntos.calculo()
    		//new Cuerpo(position = game.at())
    		//crecer 
    		})
	}
		
}

object paleta {
	const property verde = "00FF00FF"
}
object puntos{
	var puntos = 0
	method text() = puntos.toString()
	method textColor() = paleta.verde()
	method position() = game.at(0,11)
	method calculo(){
		puntos += 132
	} 
}

class Cuerpo{
	
	var property position = game.at(0,7)
	var property ultimo = "derecha"
	var imagen = "cuadrado.jpeg"
	
	method position() = position
	method image() = imagen
	
	method iniciar(){
		game.onTick(100,"moverSerpienteRight", {self.moverRight()})
		
		keyboard.right().onPressDo({ 
			self.casos()
			ultimo = "derecha"
			game.onTick(100,"moverSerpienteRight", {self.moverRight()})
		})
		
		keyboard.up().onPressDo{
			self.casos()
			ultimo = "arriba"
			game.onTick(100,"moverSerpienteUp", {self.moverUp()})
		}
		
		keyboard.down().onPressDo{ 
			self.casos()
			ultimo = "abajo"
			game.onTick(100,"moverSerpienteDown", {self.moverDown()})
		}
		
		keyboard.left().onPressDo{ 
			self.casos()
			ultimo = "izquierda"
			game.onTick(100,"moverSerpienteLeft", {self.moverLeft()})
		}
		
		self.chocar()
	}
		
	method casos(){
		if(ultimo == "derecha"){
			self.detenerRight()
		}
		if(ultimo == "arriba"){
			self.detenerUp()
		}
		if(ultimo == "abajo"){
			self.detenerDown()
		}
		if(ultimo == "izquierda"){
			self.detenerLeft()
		}
		
	}
	
	method moverRight(){
		position = position.right(1)
		if (position.x() == 17){
			position = game.at(0,position.y())
		}
	}
	
	method detenerRight(){
		game.removeTickEvent("moverSerpienteRight")
	}
	
	method moverUp(){
		position = position.up(1)
		if (position.y() == 12){
		 position = game.at(position.x(),0)
		}
	}
	method detenerUp(){
		game.removeTickEvent("moverSerpienteUp")
	}
	//
	
	method moverDown(){
		position = position.down(1)
		if (position.y() == -1){
			position = game.at(position.x(),12)
		}
	}
	method detenerDown(){
		game.removeTickEvent("moverSerpienteDown")
	}
	//
	
	method moverLeft(){	
		position = position.left(1)
		if (position.x() == -1){
			position = game.at(17,position.y())
		}
	}
	method detenerLeft(){
		game.removeTickEvent("moverSerpienteLeft")
	}
	
	method chocar(){
		//que solo choque consigo--->GAME OVER
	}
	
} 

object gusano{
	var property position = game.center()
	
	method position() = position
	method image() = "gusanoo.png"
	
	method iniciar(){
		
	}
	
 	method mover() {
    	const x = 0.randomUpTo(game.width()).truncate(0)
    	const y = 0.randomUpTo(game.height()).truncate(0)
    // otra forma de generar números aleatorios
    // const x = (0.. game.width()-1).anyOne() 
    // const y = (0.. game.height()-1).anyOne() 
    position = game.at(x,y) 
  }
}
