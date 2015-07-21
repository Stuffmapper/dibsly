factories = angular.module('factories')

factories.factory('LocalService',[ ->
        get: (key)->
          localStorage.getItem(key)

        set: (key,value)->
          localStorage.setItem(key,value)
        unset: (key)->
          localStorage.removeItem(key)
])
