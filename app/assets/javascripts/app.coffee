stfmpr = angular.module('stfmpr',[
        'templates',
        'controllers',
        'ngRoute',
        'ngResource',
        'uiGmapgoogle-maps',
        'ui.bootstrap',
        'angular-flash.service',
        'angular-flash.flash-alert-directive'
        
		
])


 
controllers = angular.module('controllers',[])

stfmpr.config( (uiGmapGoogleMapApiProvider)-> 
    uiGmapGoogleMapApiProvider.configure({
      
        v: '3.17',
        libraries: 'weather,geometry,visualization'
 	})
)	

stfmpr.config ($httpProvider) ->
  # read CSRF token
  token = $("meta[name=\"csrf-token\"]").attr("content")

  # include token in $httpProvider default headers
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = token




