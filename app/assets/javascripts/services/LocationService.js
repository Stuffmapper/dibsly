 factories = angular.module('factories');

 factories.factory('LocationService',[ '$q', '$timeout', function($q, $timeout){

        return {

          get: function() {
            var deferred = $q.defer();
            deferred.hasBeenReturned = false;
            var success = function(position){
              deferred.hasBeenReturned = true;
              deferred.resolve(position);
            };
            var error =  function(err){
              deferred.hasBeenReturned = true;
              if(!deferred.somethingWentWrong){
                deferred.somethingWentWrong = true;
                deferred.reject(err);
              }
            };
            var geoOptions = {
               enableHighAccuracy: true,
               maximumAge:300000,
               timeout: 3000 };
           if (navigator.geolocation){
            //because firefox doesn't call the error callback when you hit not now
            $timeout( function(){
             if(!deferred.hasBeenReturned){
              error(new Error('geolocation is not available')); }
            },4200  );
             navigator.geolocation.getCurrentPosition(success, error, geoOptions);

           } else {
             error(new Error('geolocation is not available'));
           }
           return deferred.promise;
         }
       };
 }]);
