 factories = angular.module('factories')

 factories.factory('ImageService',[ '$q','$http','$timeout','AlertService', function($q,$http,$timeout, AlertService){

        return {
          images: {},
          addImageGroup:function (id, image ){
            this.images[id] = { 
              original: image,
              thumbnail: image };

          },
          convert: function( maxWidth, maxHeight, file, img ) {
            var deferred = $q.defer();
            $timeout( function(){ deferred.reject(new Error('Timeout try again')) }, 5000);
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
              ctx.drawImage(img, 0, 0, width, height);
              var results = canvas.toDataURL("image/png");
              deferred.resolve(results);
            });
            reader.onload = function() {
              img.src = reader.result;
            };
            reader.readAsDataURL(file);
            console.log(reader.result)
            return deferred.promise;
         },
         createGroup: function(args){
           var self = this;
           return $q(function(resolve, reject){
             if(!self.images[args.origin]){
               self.addImageGroup(args.origin)
             } 
             var group = self.images[args.origin]
             self.convert(1000, 1000, args.file)
             .then(
              function(original){
               return group.original = original;
              },
              function(error){
                reject(error);
              }
             )
             .then( function(){
               self.convert(300, 300, args.file)
               .then(function(thumbnail){
                  group.thumbnail = thumbnail;
                  resolve(group);
                },
                function(error){
                 reject(error);
                }
               );
             });
           });
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
