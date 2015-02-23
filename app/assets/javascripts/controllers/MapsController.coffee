controllers = angular.module('controllers')

controllers.controller("MapsController", [ '$scope', 'uiGmapGoogleMapApi', 
  ($scope, uiGmapGoogleMapApi )->
  

    map_object = { center:{latitude:0,longitude:0} , zoom: 17 }
    $scope.map = map_object
    center = navigator.geolocation.getCurrentPosition((position)->
      $scope.$apply(->
        $scope.map.center.latitude =  position.coords.latitude
        $scope.map.center.longitude = position.coords.longitude  )
      )
    uiGmapGoogleMapApi.then((maps) ->
      )


])