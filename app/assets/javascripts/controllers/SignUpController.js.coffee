controllers = angular.module('controllers')
controllers.controller('SignUpCtrl', [ '$scope', '$modal', '$log',
 ($scope, $modal, $log)-> 

 

  $scope.open = (size) -> 

    modalInstance = $modal.open(
      templateUrl: 'signUp.html',
      controller: 'ModalInstanceCtrl',
      size: size,
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

controllers.controller('ModalInstanceCtrl', [ '$scope', '$modalInstance', 
 ($scope, $modalInstance ) -> 

  

  $scope.cancel = ->  
    $modalInstance.dismiss('cancel')
  
])
