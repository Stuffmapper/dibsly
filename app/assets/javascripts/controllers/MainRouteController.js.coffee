controllers = angular.module('controllers', )
controllers.controller('MainRouteCtrl',['$scope','$modal','$routeParams','$resource','UserService',

    ($scope,$modal,$routeParams,$resource,UserService)->

        if $routeParams.modalId == 'signin'
            $modal.open
                templateUrl:'signIn.html',
                controller:'SignUpCtrl'
        if $routeParams.modalId == 'signup'
            $modal.open
                templateUrl:'signUp.html',
                controller:'SignUpCtrl'
        if $routeParams.modalId == 'reset'
            $modal.open
                templateUrl:'changePw.html',
                controller: 'ResetCtrl'
        if $routeParams.modalId == 'inbox'
            $modal.open
                templateUrl:'inbox.html',
                controller: 'MessagesCtrl'



])
      