
controllers = angular.module('controllers', )
controllers.controller("MapsCtrl", [ '$scope','$http',
  ($scope, $http)->
    # $scope.$watchCollection('MapsService', ->
    #         $scope.map = MapsService.stuffMap   
    #     )

    # updateMarkers = ->
    #   map2 = $scope.map.control.getGMap()
    #   neBounds = map2.getBounds().getNorthEast()
    #   swBounds = map2.getBounds().getSouthWest()
    #   $http(
    #      url: '/posts/geolocated'
    #      params: 
    #          neLat: neBounds.lat()
    #          swLat: swBounds.lat() 
    #          neLng: neBounds.lng() 
    #          swLng: swBounds.lng()
    #   ).success((data)->
    #     # $scope.markers = data.posts
    #     MapsService.addMarkers( data.posts )
    #     $scope.markers = MapsService.markers 
        
    #     )

      
    
    # MapsService.gMap({
    #                zoom: 12 
    #                bounds: {}
    #                control: {}
    #                events:
    #                 zoom_changed: -> updateMarkers() 
    #                 dragend: -> updateMarkers() 
    #                 click: -> console.log('not working')
    #               })


    $scope.$on('mapInitialized', (evt, map) ->
      navigator.geolocation.getCurrentPosition((position)->
        console.log(position)
        $scope.$apply(->
          map.setCenter(position)
          )
        )
      )



])

