var controllers, directives, factories, filters, stfmpr;

stfmpr = angular.module('stfmpr', ['templates', 'controllers', 'factories', 'filters', 'directives', 'ng', 'ngRoute', 'ngResource', 'dcbImgFallback', 'ngAnimate', 'ui.bootstrap', 'angular-flash.service', 'angular-flash.flash-alert-directive', 'yaru22.angular-timeago']);

controllers = angular.module('controllers', []);

factories = angular.module('factories', []);

directives = angular.module('directives', []);

filters = angular.module('filters', []);

stfmpr.config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);
    return $routeProvider.when('/', {
      templateUrl: 'home.html',
      controller: 'StuffCtrl'
    }).when('/_=_', {
      templateUrl: 'home.html',
      controller: 'StuffCtrl'
    }).when('/user/:modalId', {
      templateUrl: 'home.html',
      controller: 'MainRouteCtrl'
    }).when('/user/email/:userKey', {
      templateUrl: 'verifyEmail.html',
      controller: 'EmailVerifyCtrl'
    }).when('/user/:modalId/:user', {
      templateUrl: 'home.html',
      controller: 'MainRouteCtrl'
    }).when('/menu/:menuState', {
      templateUrl: 'home.html',
      controller: 'StuffCtrl'
    }).when('/menu/:menuState/:next', {
      templateUrl: 'home.html',
      controller: 'StuffCtrl'
    }).when('/post/:postId', {
      templateUrl: "home.html",
      controller: 'StuffCtrl'
    });
  }
]);

stfmpr.config(function($resourceProvider) {
  return $resourceProvider.defaults.stripTrailingSlashes = false;
});

stfmpr.config(function($httpProvider) {
  var token;
  token = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = token;
  return $httpProvider.interceptors.push('AuthInterceptor');
});

stfmpr.run([
  'UserService', '$location', '$route', '$rootScope', 'MapsService', 'MarkerService', function(UserService, $location, $route, $rootScope, MapsService, MarkerService) {
    var original;
    original = $location.path;
    $location.path = function(path, reload) {
      var lastRoute, un;
      if (reload === false) {
        lastRoute = $route.current;
        un = function() {
          return $rootScope.$on('$locationChangeSuccess', function() {
            return $route.current = lastRoute;
          });
        };
        un();
      }
      return original.apply($location, [path]);
    };
    MapsService.loadMap();
    MarkerService.expireMarkers();
    return UserService.check();
  }
]);
