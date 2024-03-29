
directives = angular.module('directives')

directives.directive('alerts', ->
    restrict:'E'
    controller:['$scope','AlertService', ($scope,AlertService)->
        $scope.getAlerts = ->
            AlertService.get()
            
        $scope.closeAlert = (idx) ->
            AlertService.remove(idx)
        ]
    replace:true,
    template:'<alert class="sm-alert" ng-repeat="alert in getAlerts()" type="{{alert.type}}" close="closeAlert(alert.id)">{{alert.text}}</alert>'
)

