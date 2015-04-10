
controllers = angular.module('controllers', )
controllers.controller("MapsCtrl", [ '$scope','$http','MapsService',
  ($scope, $http, MapsService )->
    

    updateMarkers = ->
      $scope.markers = []
      neBounds = $scope.map.getBounds().getNorthEast()
      swBounds = $scope.map.getBounds().getSouthWest()
      $http(
         url: '/posts/geolocated'
         params: 
             neLat: neBounds.lat()
             swLat: swBounds.lat() 
             neLng: neBounds.lng() 
             swLng: swBounds.lng()
      ).success((data)->

        $scope.markers = data.posts
        MapsService.markers = data.posts
        for post in $scope.markers
            latlng = new google.maps.LatLng(post.coords.latitude,post.coords.longitude)
            marker = new google.maps.Marker(position: latlng, map:$scope.map,title:post.description)
        )

    $scope.$on('mapInitialized', (evt, map) ->
      updateMarkers()
      google.maps.event.addListener($scope.map, 'bounds_changed', -> updateMarkers() )

      MapsService.map = $scope.map
      navigator.geolocation.getCurrentPosition((position)->
        current_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
        $scope.$apply(->
          $scope.map.panTo(current_location)
          )
        )
      )



])

