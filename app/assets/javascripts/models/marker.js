(function() {
  var factories;

  factories = angular.module('factories');

  factories.factory('Marker', [
    '$http','LocalService','$resource', 
     function($http,LocalService,$resource ) {

      var MarkerResource = $resource('/api/posts/:id', {
        id: '@id'
      })

      var Marker = function(params){
        self = this
        angular.extend(self, params);
        self.routes = new MarkerResource({id: params.id});
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

      constructor.saveLocal = function(){
        if(!self.temporary){
          var cached =  LocalService.getJSON('markers') || {};
          var data = {};
          angular.forEach(self.baseProperties, function(value){
            if(self[value]){
              data[value] = self[value]
            }
          });
          cached[self.id] = data;
          console.log(self);
          LocalService.set('markers', JSON.stringify(cached))
        }
      };

      constructor.showEdit = function() {
        return ( self.creator && self.currentUser &&
          self.creator === self.currentUser);
      };

      constructor.showDib = function() {
        return ( !self.showEdit() && !self.isCurrentDibber && self.dibbable );
      };

      constructor.showUnDib = function() {
        return self.isCurrentDibber ? true : false 
      };

      return Marker;
  }]);

}).call(this);
