factories = angular.module('factories')

factories.factory('LocalService',[ ->
        get: (key)->
          localStorage.getItem(key)
        getJSON: (key)->
          self = this
          item = self.get(key)
          result = if item then JSON.parse(item) else item
          return result;
        set: (key,value)->
          localStorage.setItem(key,value)
        unset: (key)->
          localStorage.removeItem(key)
])
