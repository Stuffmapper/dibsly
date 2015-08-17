 factories = angular.module('factories')

 factories.factory('ImageService',[ '$q','$http', function($q,$http){

        return {
          convert: function( maxWidth, maxHeight, file ) {
            var deferred = $q.defer();
            setTimeout(function(){deferred.reject('Timeout try again') }, 10000);
            var canvas, ctx, img, reader;
            img = document.createElement('img');
            canvas = document.createElement('canvas');
            ctx = canvas.getContext("2d");
            reader = new FileReader();
            img.addEventListener("load", function() {
              var height, width;
              ctx.drawImage(img, 0, 0);
              width = img.width;
              height = img.height;
              if (width > height) {
                if (width > maxWidth) {
                  height *= maxWidth / width;
                  width = maxWidth;
                }
              } else {
                if (height > maxHeight) {
                  width *= maxHeight / height;
                  height = maxHeight;
                }
              }
              canvas.width = width;
              canvas.height = height;
              ctx = canvas.getContext("2d");
              deferred.resolve(canvas.toDataURL("image/png"));
            });
            reader.onload = function() {
              img.src = reader.result;
            };
            reader.readAsDataURL(file);
            return deferred.promise;
         },
         upload: function(image) {
          var deferred = $q.defer();
          $http.post('/api/images', {image: image } )
          .success(function(results){ deferred.resolve(results) })
          .error(function(error){
            console.error(error)
            deferred.reject(error)});



          return deferred.promise;
        },

       }
 }])
