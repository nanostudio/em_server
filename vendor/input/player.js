var Game = {
	currentPlayer: null,
	players: new Array(),

	setInfo: function(params){
		Game.currentPlayer = Game.newPlayer(params);
	},

    newPlayer: function(params) {
		var playing = false
		$.each(Game.players, function(index, player) {
			if(params.uid == player.uid) {
				playing = true
			}
		});

		if(!playing) {
	    	np = new Player(params.uid, params.name);
			Game.players.push(np);
			return np;
		}
    },

    playerExited: function(params) {
    	$.each(Game.players, function(index, player) {
    		if(player != undefined && player.uid == params.uid) {
    			Game.players.pop(index);
    			player.undraw();
    		}
    	});
    },

    updateState: function(params) {
		$('.element').remove();

    	$.each(params, function(index, param) {
    		var player = null;

	    	$.each(Game.players, function(index, p) {
	    		if(p.uid.toString() === param.uid.toString()) {
	    			player = p;
	    		}
	    	});

	    	if(player) {
	    		console.log('top: ' + param.top + ' left: ' + param.left)
	    		player.setPosition(param.top, param.left);
	    		player.draw();
		    } else {
	    		np = Game.newPlayer(param);
	    		np.draw();
	    	}
    	});
    }
}

function Player(id, name) {
	var self = this;
	self.uid = id;
	self.name = name;
	self.top = 10;
	self.left = 10;

	this.draw = function() {
		self.undraw();
		$('.area').append('<div class="element" id="' + 
			self.uid + 
			'" style="margin-left: ' + self.left + 'px; margin-top: ' + self.top + 'px;"></div>');
	}

	this.undraw = function() {
		$('#' + self.uid).remove()
	}

	this.moveUp = function(element) {
		self.top -= 5;
    }

    this.moveDown = function(element) {
		self.top += 5;
    }

    this.moveLeft = function(element) {
		self.left -= 5;
    }

    this.moveRight = function(element) {
		self.left += 5;
    }

    this.setPosition = function(top, left) {
    	self.top = parseInt(top);
    	self.left = parseInt(left);
    }
}