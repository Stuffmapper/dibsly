factories = angular.module('factories')

factories.factory('MapsService', [ '$http',
 ($http )->
 	markers: {}
 	addStuffMarker: (marker)-> 
 		if this.newMarker 
 		 	this.newMarker.setMap(null)
 		this.newMarker = marker
 		this.newMarker.setMap(this.map)

 	removeMarker: (marker_id)-> 
 		markers = this.markers
 		delete markers[marker_id]

 	addOldMarker: (stuff)-> 
 		markers = this.markers
 		markers[stuff.id] = stuff


 	updateMarkers:
 		(map)->
 			markers = this.markers
	 		neBounds = map.getBounds().getNorthEast()
	 		swBounds = map.getBounds().getSouthWest()
	 		$http(
	 			url: '/posts/geolocated'
	 			params: 
	 				neLat: neBounds.lat()
	 				swLat: swBounds.lat() 
	 				neLng: neBounds.lng()
	 				swLng: swBounds.lng()
	 			).success((data)->
	 				for marker in data.posts
	 					if not markers[marker.id]
	 						markers[marker.id] = marker )

 	rstuffMap: 
 		{}





 	gMap:
 		(options)->
		  	this.map = options

	#addStuffMarker: (marker)-> marker.setMap(this.rgMap)






	


])

