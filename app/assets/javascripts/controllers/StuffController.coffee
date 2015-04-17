
controllers = angular.module('controllers')




controllers.controller('StuffCtrl', [ '$scope','$window', 'MapsService','AlertService', '$http', 
 ($scope, $window, MapsService, AlertService, $http ) -> 
     $scope.$watch( ->
            return MapsService.newMarker
        (newValue) ->
         $scope.newMarker = newValue
         $scope.post.latitude = $scope.newMarker.getPosition().lat()
         $scope.post.longitude = $scope.newMarker.getPosition().lng()

        )
     $scope.$watch( ->
            return MapsService.markers
        (newValue) ->
         $scope.stuff = newValue

        )
     $scope.post = {}

     $scope.files = []
     $scope.$on("fileSelected",
                (event, args) -> $scope.$apply( ->  
                    $scope.files.push(args.file)
                    console.log($scope.files)
                ))

     $scope.stuff =  MapsService.markers
     $scope.mystuff = []
     $scope.getMyStuff = ->
        $http(
            url: '/my-stuff'
          ).success((data)->
            $scope.mystuff =  data.posts  )



     $scope.submitPost = ->
        formdata = new FormData();
        formdata.append('latitude', $scope.post.latitude)
        formdata.append('longitude', $scope.post.longitude)
        formdata.append('category', $scope.post.category)
        formdata.append('description', $scope.post.description)
        formdata.append('image', $scope.files[0]);
        $http.post( "/posts", formdata, {
            headers: {'Content-Type': undefined}
            transformRequest: angular.identity
            }).success (data, status, headers, config) -> 
                console.log('it worked')
                AlertService.add('success', "You've Posted Your Stuff")
                $scope.files = []
            .error (data) ->
                for key, value of data
                    AlertService.add('danger', key + ' ' + value )



          


     $scope.startMapper = ->
        google.maps.event.addListener(MapsService.map, 'click', (mapModel)->
                                                marker = new google.maps.Marker(position: mapModel.latLng, map:MapsService.map,title:'new stuff')
                                                MapsService.map.panTo(mapModel.latLng,30)
                                                MapsService.addStuffMarker(marker)
                                                $scope.post.latitude = marker.getPosition().lat()
                                                $scope.post.longitude = marker.getPosition().lng()
                                                MapsService.map.setZoom(16)
                                
                                                )



])
      

