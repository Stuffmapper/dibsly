
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
     $http(
         url: '/my-stuff'
      ).success((data)->
        $scope.mystuff =  data.posts  
        )
     $scope.giveMe = (post_id)->
        post_url = 'posts/' + post_id + '/dibs'
        $http.post(
            post_url
            ).success((data)->
                AlertService.add('success', "Dibbed your stuff")
            ).error (data) ->
                AlertService.add('danger', 'You probably need to log in')



     $scope.submitPost = ->
        formdata = new FormData();
        formdata.append('latitude', $scope.post.latitude)
        formdata.append('longitude', $scope.post.longitude)
        formdata.append('category', $scope.post.category)
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
      

