
controllers = angular.module('controllers')



controllers.controller('SignUpCtrl', [ '$scope', '$modalInstance', '$http', '$timeout','UserService','AlertService'
 ($scope, $modalInstance, $http, $timeout, UserService, AlertService ) -> 

  

  $scope.cancel = ->  
    $modalInstance.dismiss('cancel')

 


  $scope.signup = ->
    user = {
        first_name: $scope.first_name
        last_name: $scope.last_name
        username: $scope.username
        email: $scope.email
        password: $scope.password
        password_confirmation: $scope.password_confirmation 
        phone_number: $scope.phone_number
        }



    console.log(user)
    
    $http.post('/users', {user: user}  )
      .success -> 
        $modalInstance.dismiss('cancel')

  $scope.signin = ->
      UserService.login($scope.username, $scope.password,
          (err,data) ->
              if(err)
                  alert(err)
              else if(data.user)
                AlertService.add('success','You have been signed in.')
                $modalInstance.dismiss('cancel')
              else  
                alert(data.error)   
        )
])

