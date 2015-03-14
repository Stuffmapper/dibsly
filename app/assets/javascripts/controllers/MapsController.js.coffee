
controllers = angular.module('controllers', )
controllers.controller("MapsCtrl", [ '$scope','$http', 'uiGmapGoogleMapApi', 'uiGmapIsReady'
  ($scope, $http, uiGmapGoogleMapApi, uiGmapIsReady )->

    updateMarkers = ->
      map2 = $scope.map.control.getGMap()
      neBounds = map2.getBounds().getNorthEast()
      swBounds = map2.getBounds().getSouthWest()
      $http(
         url: '/posts/geolocated'
         params: 
             neLat: neBounds.lat()
             swLat: swBounds.lat() 
             neLng: neBounds.lng() 
             swLng: swBounds.lng()
      ).success((data)->
        $scope.markers = data.posts
        )

    
    map_object = {
                   zoom: 12 
                   bounds: {}
                   events:
                    zoom_changed: -> updateMarkers() 
                    dragend: -> updateMarkers() 
                  }
 
    $scope.map = map_object
    $scope.map.control = {}
   
    

    center = navigator.geolocation.getCurrentPosition((position)->
      $scope.$apply(->

        map1 = $scope.map.control.getGMap()
        map1.panTo({lat:position.coords.latitude,lng: position.coords.longitude},30)
          

        uiGmapIsReady.promise().then((maps) ->
          console.log($scope.map.bounds)
          updateMarkers()
          )
        )
      )

    uiGmapGoogleMapApi.then((maps) ->
      
     

      
    )


])

