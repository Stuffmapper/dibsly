var factories;

factories = angular.module('factories');

factories.factory('LocalService', [
  function() {
    return {
      get: function(key) {
        return localStorage.getItem(key);
      },
      getJSON: function(key) {
        var item, result, self;
        self = this;
        item = self.get(key);
        try{
          result = item ? JSON.parse(item) : item;
          return result;
        } catch(err){
        return false; }
      },
      set: function(key, value) {
        return localStorage.setItem(key, value);
      },
      setJSON: function(key, value) {
        localStorage.setItem(key, JSON.stringify(value));
      },
      unset: function(key) {
        return localStorage.removeItem(key);
      }
    };
  }
]);