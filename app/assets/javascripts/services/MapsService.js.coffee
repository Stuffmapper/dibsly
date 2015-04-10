factories = angular.module('factories')

factories.factory('MapsService', [ '$http',
 ($http )->

 	addStuffMarker: (marker)-> 
 		if this.newMarker 
 		 	this.newMarker.setMap(null)
 		this.newMarker = marker
 		this.newMarker.setMap(this.map)

 	markers:
 		[]

 	rstuffMap: 
 		{}

 	addMarkers:
 		(newMarkers)->
 
 			this.markers = newMarkers



 	gMap:
 		(options)->
		  	this.map = options

	#addStuffMarker: (marker)-> marker.setMap(this.rgMap)






	


])

