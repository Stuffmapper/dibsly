
controllers = angular.module('controllers')
controllers.controller('SignUpCtrl', [ '$scope', '$modal', '$log',
 ($scope, $modal, $log)-> 

 

  $scope.open = (type) -> 
    if type == 'signin'
      template = 'signIn.html'
    else
      template = 'signUp.html'

    modalInstance = $modal.open(
      templateUrl: template,
      controller: 'ModalInstanceCtrl',
      resolve: {
        items: -> 
          return $scope.items;
        
      }
    )

    modalInstance.result.then( (selectedItem)-> 
      $scope.selected = selectedItem
      -> 
      $log.info('Modal dismissed at: ' + new Date());
    )
  
])

#Please note that $modalInstance represents a modal window (instance) dependency.
#It is not the same as the $modal service used above.

controllers.controller('ModalInstanceCtrl', [ '$scope', '$modalInstance', '$http',
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

