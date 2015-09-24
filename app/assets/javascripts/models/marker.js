(function() {
  var factories;

  factories = angular.module('factories');

  factories.factory('Marker', [
    '$http','LocalService','$resource', 
     function($http,LocalService,$resource ) {

      var Marker = $resource('/api/posts/:id', {
        id: '@id'
      })

      var Marker = function(params){
        if (!params.id){ throw new Error('id is required')}
        var self = this;
        angular.extend(self, params);
        console.log('inside marker line 18');
      };

      var constructor = Marker.prototype;

      constructor.baseProperties = [ 
        'id', 
        'category',
        'description',
        'latitude',
        'longitude',
        'published',
        'title'
      ];
      //TODO make this work with angular resource
      constructor.url = function(){
        return '/api/posts/' + this.id
      };

      // create
      constructor.save = function(){
        throw new Error('function not yet implemented')
        //updates the server

      };

      // read
      constructor.get = function(){
        //gets new data from 
        throw new Error('function not yet implemented')
        
      };

      // update
      constructor.update = function(){
        //updates this post
        throw new Error('function not yet implemented')
        
      };

      // delete
      constructor.remove = function(){
        //removes from local cache 
        //deletes on the server
        //does not delete itself .. will need to be handle else where
        //should mark for deletion
        throw new Error('function not yet implemented')
        
      };

      //TODO - add a dib function?

      //TODO crud routes
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

      return Marker;
  }]);

}).call(this);
