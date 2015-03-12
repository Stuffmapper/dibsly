
controllers = angular.module('controllers', )
controllers.controller("MapsCtrl", [ '$scope', 'uiGmapGoogleMapApi', 'uiGmapIsReady'
  ($scope, uiGmapGoogleMapApi, uiGmapIsReady )->
    
    
    map_object = { center:{latitude:,longitude:} , zoom: 17 }
    console.log(window.location)
 
    $scope.map = map_object
    $scope.map.control = {}
    center = navigator.geolocation.getCurrentPosition((position)->
      $scope.$apply(->
        $scope.map.center.latitude =  position.coords.latitude
        $scope.map.center.longitude = position.coords.longitude  

        uiGmapIsReady.promise().then((maps) ->
          map1 = $scope.map.control.getGMap()
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

