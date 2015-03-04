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

stfmpr.config( ['$routeProvider','$locationProvider', 'uiGmapGoogleMapApiProvider',


    ($routeProvider,$locationProvider,uiGmapGoogleMapApiProvider)->

      $locationProvider.html5Mode(true)

      $routeProvider
        .when('/', {
          templateUrl:'home.html',
          controller: 'MapsCtrl'
        })
        .when('/signup',{
          templateUrl:'signUp.html',
          controller:'SignUpCtrl'
        })
        .when('/signin',{
          templateUrl:'signIn.html',
          controller:'SignUpCtrl'
        })
   

      uiGmapGoogleMapApiProvider.configure({
      
        v: '3.17',
        libraries: 'weather,geometry,visualization'
      })

])	





stfmpr.config ($httpProvider) ->
  # read CSRF token
  token = $("meta[name=\"csrf-token\"]").attr("content")

  # include token in $httpProvider default headers
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = token




