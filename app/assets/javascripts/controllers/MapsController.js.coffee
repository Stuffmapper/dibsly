
controllers = angular.module('controllers', )
controllers.controller("MapsCtrl", [ '$scope', 'uiGmapGoogleMapApi', 'uiGmapIsReady'
  ($scope, uiGmapGoogleMapApi, uiGmapIsReady )->
    
    
    map_object = { center:{latitude:'0',longitude:'47'} , zoom: 17 }
    console.log(window.location)
 
    $scope.map = map_object
    $scope.map.control = {}
    center = navigator.geolocation.getCurrentPosition((position)->
      $scope.$apply(->
        
        map1 = $scope.map.control.getGMap()
        map1.panTo({lat:position.coords.latitude,lng: position.coords.longitude},30)


        uiGmapIsReady.promise().then((maps) ->
          console.log(map1.getBounds().toUrlValue()) 
         )
        )
      )
    $scope.marker = {
      id: 0,
      coords: {
        latitude: 47.547,
        longitude: -122.386
      }
    } 

    uiGmapGoogleMapApi.then((maps) ->
      
    )


])

