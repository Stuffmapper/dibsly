factories = angular.module('factories')

factories.factory('MapsService', [ '$http','uiGmapIsReady','uiGmapGoogleMapApi'
 ($http,uiGmapIsReady,uiGmapGoogleMapApi)->
 	rgMap: (gmappy)-> 
 		this.rstuffMap = gmappy
 

 	addStuffMarker: (marker)-> 
 		if this.newMarker 
 		 	this.newMarker.setMap(null)
 		this.newMarker = marker
 		this.newMarker.setMap(this.rstuffMap)

 	markers:
 		[]
 	stuffMap:
 		{events:{}, zoom:12, control:{} }
 	rstuffMap: 
 		{}

 	addMarkers:
 		(newMarkers)->
 
 			this.markers = newMarkers

 	increaseListeners: 
 		(listener,funname)->  
 			this.stuffMap.events[listener] = funname

 	gMap:
 		(options)->
		  	this.stuffMap = options

	#addStuffMarker: (marker)-> marker.setMap(this.rgMap)






	


])

