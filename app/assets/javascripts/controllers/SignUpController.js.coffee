
controllers = angular.module('controllers')



controllers.controller('SignUpCtrl', [ '$scope', '$modalInstance', '$http',
 ($scope, $modalInstance, $http ) -> 

  

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
    user = {
        username: $scope.username
        password: $scope.password
        }

    
    $http.post('/sessions/create', user  )
      .success -> 
        $modalInstance.dismiss('cancel')
  
])

