# factories = angular.module('factories')
#
# factories.factory('LocationService',[ ->
#         get: (success, error )->
#           geoOptions = {
#             enableHighAccuracy: true,
#             maximumAge:300000,
#             timeout: timeout }
#           if navigator.geolocation
#             navigator.geolocation.getCurrentPosition(success, error, geoOptions)
#           else
#             error()
#
#         set: (key,value)->
#           localStorage.setItem(key,value)
#         unset: (key)->
#           localStorage.removeItem(key)
# ])
#
#
#         centerSuccess = (position)->
#           center = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
#           updateMarker(center)
#         centerError = ->
#           console.log("geolocation not supported or error")
#           center = $scope.map.getCenter()
#           updateMarker(center)
#         geoOptions = {
#           enableHighAccuracy: true,
#           maximumAge:300000,
#           timeout: timeout }
#         navigator.geolocation.getCurrentPosition(centerSuccess,centerError, geoOptions)
