stfmpr = angular.module('stfmpr',[
        'templates',
        'controllers',
        'factories',
        'filters',
        'directives',
        'ng',
        'ngRoute',
        'ngResource',
        'ngMap',
        'dcbImgFallback',
        'ui.bootstrap',
        'angular-flash.service',
        'angular-flash.flash-alert-directive',
        'yaru22.angular-timeago'

])

controllers = angular.module('controllers',[])
factories = angular.module('factories',[])
directives = angular.module('directives',[])
filters = angular.module('filters',[])
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
          templateUrl:'verifyEmail.html',
          controller: 'EmailVerifyCtrl'
        })
        .when('/user/:modalId/:user',{
          templateUrl:'home.html',
          controller:'MainRouteCtrl'
        })
        .when('/menu/:menuState',{
          templateUrl:'home.html',
          controller:'StuffCtrl'
        })
        .when('/post/:postId',{
          templateUrl: "home.html"
          controller: 'StuffCtrl'
       })



])



stfmpr.config ($resourceProvider) ->
  $resourceProvider.defaults.stripTrailingSlashes = false


stfmpr.config ($httpProvider) ->
  # read CSRF token
  token = $("meta[name=\"csrf-token\"]").attr("content")

  # include token in $httpProvider default headers
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = token
  $httpProvider.interceptors.push('AuthInterceptor')


stfmpr.run(['UserService','$location','$route','$rootScope', (UserService, $location, $route, $rootScope)->
    original = $location.path
    $location.path = (path,reload)->
      if reload == false
        lastRoute = $route.current
        un = -> $rootScope.$on('$locationChangeSuccess', ->
          $route.current = lastRoute
          )
        un()
      original.apply($location, [path])
    return UserService.check()
])
