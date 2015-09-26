(function() {
  var factories;

  factories = angular.module('factories');

  factories.factory('Marker', [
    '$http','LocalService','$resource', '$q', 
     function($http,LocalService,$resource, $q ) {


      var Marker = function(params){
        if (!params.id){ throw new Error('id is required')}
        var self = this;
        angular.extend(self, params);
      };

      var constructor = Marker.prototype;

      constructor.baseProperties = [ 
        'id', 
        'category',
        'description',
        'latitude',
        'longitude',
        'published',
        'title',
        'status',
        'image_url'
      ];
      //TODO make this work with angular resource
      //Read the source code for angular resource to confirm  
      constructor.getUrl = function(){
        return '/api/posts/' + this.id
      };

      // create
      constructor.create = function(customURL){
        //NOTE a controller will have to wrap this function to change
        //the key in the marker service and set the marker on success
        var self = this;
        var url = customURL || '/api/posts'
        var params = {};
        angular.forEach(self.baseProperties, function(property){
          params[property] =  self[property];
        })
        return $q(function(resolve, reject){
          $http.post(url, params)
          .then( function(data){
            self.status = 'new'; //review
            var updated = data.data.post;
            angular.extend(self, updated)
            self.saveLocal();
            resolve(updated) },
            function(error){
              //TODO handle specific errors
              reject(error);
          }); 
        });
      };

      // read
      constructor.get = function(){
        //gets new data from 
        //throw new Error('function not yet implemented')
        var self = this;
        return $q(function(resolve, reject){
          $http.get(self.getUrl())
          .success(function(data){
            angular.extend(self, data.post)
            self.saveLocal();
            resolve(self)
          })
          .error(function(err){
            reject(error)
          })

        });
      };

      // update
      constructor.update = function(){
        //updates this post
        // new images should be handled seperately
        var self = this;
        return self.create(self.getUrl())
        
      };

      // delete
      constructor.remove = function(){
        var self = this;
        //removes from local cache 
        //deletes on the server
        //does not delete itself .. will need to be handle else where
        //should mark for deletion
        return $q(function(resolve, reject){
          $http.delete(self.getUrl() + '/remove')
          .success( function(data){
            angular.extend(self, data.post)
            self.deleteLocal();
            resolve(self)
          })
          .error( function(error){
            throw new Error( "can't delete " + self )
          })
        });
      };

      constructor.rejectDibber = function(){
        var self = this;
        //removes from local cache 
        //deletes on the server
        //does not delete itself .. will need to be handle else where
        //should mark for deletion
        return $q(function(resolve, reject){
          $http.post(self.getUrl() + '/removecurrentdib')
          .success( function(data){
            angular.extend(self, data.post)
            resolve(self)
          })
          .error( function(error){
            throw new Error( "can't delete " + self )
          })
        });
      };

      //TODO - add a dib function?

      constructor.saveLocal = function(){
        var self = this;
        if(!self.temporary && self.id){ //TODO and more validations
          var cached =  LocalService.getJSON('markers') || {};
          var data = {};
          angular.forEach(self.baseProperties, function(value){
            if(self[value]){
              data[value] = self[value]
            }
          });
          cached[self.id] = data;
          LocalService.set('markers', JSON.stringify(cached))
        }
      };
      constructor.deleteLocal = function(){
        var self = this;
        var cached =  LocalService.getJSON('markers') || {};
        if(cached[self.id]){
         delete cached[self.id];
        }
        LocalService.set('markers', JSON.stringify(cached))
      };

      constructor.showEdit = function() {
        return ( this.creator && this.currentUser &&
          this.creator === this.currentUser);
      };

      constructor.showDib = function() {
        return ( !this.showEdit() && !this.isCurrentDibber && this.dibbable );
      };

      constructor.showUnDib = function() {
        return this.isCurrentDibber ? true : false 
      };

      constructor.showWanted = function() {
        //TEST ME
        return ( this.showEdit() && this['status'] === 'dibbed' );
      };

      return Marker;
  }]);

}).call(this);
