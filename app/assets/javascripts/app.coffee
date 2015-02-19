stfmpr = angular.module('stfmpr',[
        'controllers',
        'uiGmapgoogle-maps'
		
])


 
controllers = angular.module('controllers',[])

stfmpr.config( (uiGmapGoogleMapApiProvider)-> 
    uiGmapGoogleMapApiProvider.configure({
      
        v: '3.17',
        libraries: 'weather,geometry,visualization'
 	})
)	
controllers.controller("MapsController", [ '$scope', 'uiGmapGoogleMapApi', 
  ($scope, uiGmapGoogleMapApi )->
   $scope.map = { center: { latitude: 45, longitude: -73 }, zoom: 8 };
   uiGmapGoogleMapApi.then((maps) ->) 


])