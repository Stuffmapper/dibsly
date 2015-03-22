
controllers = angular.module('controllers')




controllers.controller('StuffCtrl', [ '$scope','$window', 'MapsService', '$http',
 ($scope, $window, MapsService, $http ) -> 
     $scope.$watch( ->
            return MapsService.newMarker
        (newValue) ->
         console.log("watched", newValue)
         $scope.newMarker = newValue
         $scope.post.latitude = $scope.newMarker.getPosition().lat()
         $scope.post.longitude = $scope.newMarker.getPosition().lng()

        )
     $scope.tabs = [ { title:'Stuff', content:'Stuff', active: 'true'},
        { title:'My Stuff', content:'My Stuff Here'}
        ]
     $scope.post = {}

     $scope.files = []
     $scope.$on("fileSelected",
                (event, args) -> $scope.$apply( ->  
                    $scope.files.push(args.file)
                    console.log($scope.files)
                ))


     $scope.submitPost = ->
        formdata = new FormData();
        formdata.append('post', angular.toJson($scope.post))
        formdata.append('image_url', $scope.files[0]);
        $http.post( "/posts", formdata, {
            headers: {'Content-Type': undefined}
            transformRequest: angular.identity
            }).success (data, status, headers, config) -> 
                console.log('it worked')
            .error (data, status, headers, config) ->
                console.log('it DID NOT work')



          


     $scope.startMapper = ->
        MapsService.increaseListeners('click', (mapModel, eventName, originalEventArgs)->
                                                lat = originalEventArgs[0].latLng.lat()
                                                lng = originalEventArgs[0].latLng.lng()
                                                newMarker =
                                                    new google.maps.Marker({
                                                    position: originalEventArgs[0].latLng
                                                    title:"Hello World!"
                                                    })


                                                MapsService.addStuffMarker(newMarker)

                                                MapsService.rstuffMap.panTo({lat:lat,lng: lng},30)
                                
                                                )



])
      

