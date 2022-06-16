

class error inherits Exception {
	
	override method message() {
		return message
	}
}

object abc {
	
	method asd () {
		return new error()
	}
	
}