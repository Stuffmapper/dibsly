factories = angular.module('factories')

factories.factory('MapsService', [ '$http',
 ($http )->
 	markers: {}

 	addStuffMarker: (marker)-> 
 		if this.newMarker 
 		 	this.newMarker.setMap(null)
 		this.newMarker = marker
 		this.newMarker.setMap(this.map)

 	updateMarker: (stuff)-> 
 		self = this
 		if self.markers[stuff.id] 
 			delete self.markers[stuff.id] 
 		else
 			self.markers[stuff.id] = stuff

 	

 	gMap:
 		(options)->
		  	this.map = options

	#addStuffMarker: (marker)-> marker.setMap(this.rgMap)






	


])

