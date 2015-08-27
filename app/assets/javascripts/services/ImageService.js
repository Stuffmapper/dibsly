 factories = angular.module('factories')

 factories.factory('ImageService',[ '$q','$http','AlertService', function($q,$http, AlertService){

        return {
          images: {},
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
              ctx.drawImage(img, 0, 0, width, height);
              var results = canvas.toDataURL("image/png");
              deferred.resolve(results);
            });
            reader.onload = function() {
              img.src = reader.result;
            };
            reader.readAsDataURL(file);
            return deferred.promise;
         },
         createGroup: function(args){
           var self = this;
           if(!self.images[args.origin]){
             self.images[args.origin] = [];
           } else if (self.images[args.origin].length >= 1) {
             AlertService.add('warning', "Please only upload only one file");
           }
           var group = {};
           self.convert(1000, 1000, args.file)
           .then(function(original){
             group.original = original;
           })
           .then( function(){
             self.convert(300, 300, args.file)
             .then(function(thumbnail){
               group.thumbnail = thumbnail;
               self.images[args.origin].unshift(group);
             })
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
