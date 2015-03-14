
controllers = angular.module('controllers')



controllers.controller('StuffCtrl', [ '$scope','$window',
 ($scope, $window ) -> 
	  $scope.tabs = [
	    { title:'Stuff', content:'Stuff'},
	    { title:'Get Stuff', content:'Get Stuff Here'},
	    { title:'My Stuff', content:'My Stuff Here'}
	  ]

	  $scope.alertMe = -> 
	    setTimeout( -> 
	      $window.alert('You\'ve selected the alert tab!')
	    )
	])
  

