import wollok.game.* 
import juego.*

object consola {

	const juegos = [
		new Juego(color = "Amarillo"),
		new Juego(color = "Verde"),
		new Juego(color = "Rojo"),
		new Juego(color = "Azul"),
		new Juego(color = "Naranja"),
		new Juego(color = "Violeta")
	]
	var menu 
	
	method initialize(){
		game.height(12)
		game.width(17)
		game.title("Consola de juegos")
	}
	
	method iniciar(){
		menu = new MenuIconos(posicionInicial = game.center().left(2))	
		game.addVisual(menu)
		juegos.forEach{juego=>menu.agregarItem(juego)}
		menu.dibujar()
		keyboard.enter().onPressDo{self.hacerIniciar(menu.itemSeleccionado())}
		
	}
	
	method hacerIniciar(juego){
		game.clear()
		keyboard.q().onPressDo{self.hacerTerminar(juego)}
		juego.iniciar()
	}
	method hacerTerminar(juego){
		juego.terminar()
		game.clear()
		self.iniciar()
	}
}


class MenuIconos{
	var seleccionado = 1
	const ancho = 3
	const espaciado = 2
	const items = new Dictionary() 
	var posicionInicial
	
	method initialize(){
		keyboard.up().onPressDo{self.arriba()}
		keyboard.down().onPressDo{self.abajo()}
		keyboard.right().onPressDo{self.derecha()}
		keyboard.left().onPressDo{self.izquierda()}
	}
	
	method agregarItem(item){
		items.put(items.size()+1, item)
	}

	method dibujar(){
		items.forEach{indice,visual => 
			visual.position(self.posicionDe(indice))
			game.addVisual(visual)
		}
	}
	
	method horizontal(indice) = (indice-1)% ancho * espaciado
	method vertical(indice) = (indice-1).div(ancho) * espaciado
	
	method posicionDe(indice) =
		posicionInicial
			.up(self.vertical(indice))
			.right(self.horizontal(indice))

	method itemSeleccionado() = items.get(seleccionado)
	method image() = "cursor.png"
	method position() = self.posicionDe(seleccionado)

	method abajo(){
		if(seleccionado > ancho) seleccionado = seleccionado - ancho	
	}
	method arriba(){
		if(seleccionado + ancho <= items.size()) seleccionado = seleccionado + ancho	
	}
	method derecha(){
		seleccionado = (seleccionado + 1).min(items.size())
	}
	method izquierda(){
		seleccionado = (seleccionado - 1).max(1)
	}
}

class Rectangulo {
	var posicion = game.at(0,0)
	var color = "Rojo"
}

object juego{
	const Rectangulos = [
		new Rectangulo( posicion = game.at(7,9) , color = "Rojo"),
		new Rectangulo( posicion = game.at(8,9) , color = "Rojo"),
		new Rectangulo( posicion = game.at(9,9) , color = "Rojo"),
		new Rectangulo( posicion = game.at(10,9) , color = "Rojo"),
		
		
		new Rectangulo( posicion = game.at(7,8) , color = "Azul"),
		new Rectangulo( posicion = game.at(8,8) , color = "Azul"),
		new Rectangulo( posicion = game.at(9,8) , color = "Azul"),
		new Rectangulo( posicion = game.at(10,8) , color = "Azul"),
	
		
		new Rectangulo( posicion = game.at(7,7) , color = "Verde"),
		new Rectangulo( posicion = game.at(8,7) , color = "Verde"),
		new Rectangulo( posicion = game.at(9,7) , color = "Verde"),
		new Rectangulo( posicion = game.at(10,7) , color = "Verde"),
	
		
		new Rectangulo( posicion = game.at(7,6) , color = "Amarillo"),
		new Rectangulo( posicion = game.at(8,6) , color = "Amarillo"),
		new Rectangulo( posicion = game.at(9,6) , color = "Amarillo"),
		new Rectangulo( posicion = game.at(10,6) , color = "Amarillo"),
	
	]
	
	method iniciar(){
		game.addVisual()
		game.whenCollideDo(pelota, { elemento => game.removeVisual(elemento)}
	}
}

