 factories = angular.module('factories')

 factories.factory('LocationService',[ '$q', function($q){

        return { get: function() {
            var deferred = $q.defer();
            var success = function(position){ deferred.resolve( position )};
            var error =  function(err){ console.log(err); return  deferred.reject(err)};
            var geoOptions = {
               enableHighAccuracy: true,
               maximumAge:300000,
               timeout: 5000 };
           if (navigator.geolocation){
             navigator.geolocation.getCurrentPosition(success, error, geoOptions)

           } else { error(new Error('geolocation is not available')) }

           return deferred.promise;
         }
       }
 }])
