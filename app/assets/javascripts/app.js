var controllers, directives, factories, filters, stfmpr;

stfmpr = angular.module('stfmpr', ['templates', 
  'controllers',
  'factories',
  'filters',
  'directives', 
  'ng',
  'ngResource',
  'dcbImgFallback',
  'ngAnimate',
  'ui.bootstrap',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'ui.router'
]);

controllers = angular.module('controllers', []);

factories = angular.module('factories', []);

directives = angular.module('directives', []);

filters = angular.module('filters', []);



stfmpr.config(function($stateProvider, $urlRouterProvider) {
     
     $urlRouterProvider.rule(function ($injector, $location) {
        var path = $location.path(), normalized = path.toLowerCase();
        if (path != normalized && !path.match(/email/)) {
          console.log(path)
            //instead of returning a new url string, I'll just change the $location.path directly so I don't have to worry about constructing a new url string and so a new state change is not triggered
            $location.replace().path(normalized);
        }
        // because we've returned nothing, no state change occurs
    });  

  // For any unmatched url, redirect to /state1
  $urlRouterProvider.when("/givestuff", 'giveStuffOne');
  $urlRouterProvider.otherwise("/menu/getstuff");

  $stateProvider
    .state({
      name: 'menu',
      url: "/menu",
      templateUrl: 'home.html',
      controller: 'MenuCtrl'
    })
    .state({
      name: 'getStuff',
      url: "/getstuff",
      templateUrl:"menu/getstuff.html",
      controller: 'GetStuffCtrl',
      parent: 'menu'
    })
    .state('verifyemail', {
      url: "/users/email/:userKey",
      templateUrl: 'verifyEmail.html',
      controller: 'EmailVerifyCtrl'
    }) 
    .state( 'singlepost', {
      url:'/post/:postId',
      template: "<smdetails post='post'></smdetails>",
      controller: [ '$scope','$stateParams','$q', 'MarkerService', 'MapsService', 
        function($scope,$stateParams,$q,MarkerService,MapsService){
          var id = $stateParams.postId;
          $scope.post = {};
          var local =MarkerService.getMarker(id);
          $q.when( local || MarkerService.getMarkerAsync(id))
          .then(function(marker){ 
            $scope.post = marker;
            $q.when(!local || $scope.post.get())//only updates if info pulled from cach
            .then(function(){ 
              MarkerService.updateWindow(id);
              MarkerService.clearWindows(id);
              MapsService.panToMarker( $scope.post.marker )} );
           }, function(){ }  )//todo add 404; 
      }],
      parent:'menu'
    })
    .state( 'edit', {
      url:'/post/edit/:postId',
      templateUrl: "menu/editstuff.html",
      controller: 'EditStuffCtrl',
      parent:'menu'
    })
    .state( 'giveStuff', {
      url:'/givestuff',
      template: "<div ui-view></div>",
      controller: ['$state', function($state){ 
        if($state.$current.name === 'giveStuff'){
          $state.go('giveStuffOne');
        }
      }],
      parent: 'menu'
    })
    .state( 'giveStuffOne', {
      url:'/1',
      templateUrl: "menu/givestuff.one.html",
      controller: 'GiveStuffCtrl',
      parent: 'giveStuff'
    })
    .state( 'giveStuffTwo', {
      url:'/2',
      templateUrl: "menu/givestuff.two.html",
      controller: 'GiveStuffCtrl',
      parent: 'giveStuff'
    })
    .state( 'myStuff', {
      url:'/mystuff',
      templateUrl: "myStuff/myindex.html",
      controller: 'MyStuffCtrl',
      parent: 'menu'
    })
    .state( 'user', {
      url:'/user',
      templateUrl: "menu/user-settings.html",
      controller: 'UserCtrl',
      parent: 'menu'
    })
    .state( 'user.verifyEmail', {
      url:'/user/email/:userKey',
      templateUrl: "verifyEmail.html",
      controller: 'EmailVerifyCtrl',
    })
    .state( 'resetPassWord', {
      url:'/user/email/reset/:userKey',
      templateUrl: "changePw.html",
      controller: 'ResetCtrl',
      parent: 'menu'
    });

});



stfmpr.config(function($resourceProvider) {
  return $resourceProvider.defaults.stripTrailingSlashes = false;
});

stfmpr.config(function($httpProvider) {
  var token;
  token = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = token;
  return $httpProvider.interceptors.push('AuthInterceptor');
});

stfmpr.run(['$state','UserService', '$location','$rootScope', 'MapsService', 'MarkerService',
  function($state,UserService, $location, $rootScope, MapsService, MarkerService) {
    MapsService.loadMap();
    UserService.check();
    //$state.lastState = ($state.lastState || 'getStuff');
  }
]);

