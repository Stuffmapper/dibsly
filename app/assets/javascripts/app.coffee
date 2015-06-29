stfmpr = angular.module('stfmpr',[
        'templates',
        'controllers',
        'factories',
        'directives',
        'ngRoute',
        'ngResource',
        'ngMap',
        'ui.bootstrap',
        'angular-flash.service',
        'angular-flash.flash-alert-directive',
        'yaru22.angular-timeago'

])



controllers = angular.module('controllers',[])
factories = angular.module('factories',[])
directives = angular.module('directives',[])

stfmpr.config( ['$routeProvider','$locationProvider',


    ($routeProvider,$locationProvider)->


      $locationProvider.html5Mode(true)

      $routeProvider
        .when('/', {
          templateUrl:'home.html',
          controller: 'StuffCtrl'
        })
        .when('/_=_', {
          templateUrl:'home.html',
          controller: 'StuffCtrl'
        })
        .when('/user/:modalId',{
          templateUrl:'home.html',
          controller:'MainRouteCtrl'
        })
        .when('/user/email/:userKey',{
          templateUrl:'home.html',
          controller:'EmailVerifyCtrl'
        })
        .when('/user/:modalId/:user',{
          templateUrl:'home.html',
          controller:'MainRouteCtrl'
        })
        .when('/post/:postId',{
          templateUrl: "post.html"
          controller: 'StuffViewCtrl'
       })



])



stfmpr.config ($resourceProvider) ->
  $resourceProvider.defaults.stripTrailingSlashes = false


stfmpr.config ($httpProvider) ->
  # read CSRF token
  token = $("meta[name=\"csrf-token\"]").attr("content")

  # include token in $httpProvider default headers
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = token


stfmpr.run(['UserService',(UserService)->

    UserService.check((err,data)->
        console.log('check',err,data)
      )
])
