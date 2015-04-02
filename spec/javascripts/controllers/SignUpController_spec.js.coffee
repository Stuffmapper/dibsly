describe "SignUpController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash        = null
  location     = null
 



  setupController = ->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, $modal, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      modal       = $modal
      flash = _flash_

      fakeModal = { 
        result: 
            then: (confirmCallback, cancelCallback) ->
                #Store the callbacks for later when the user clicks on the OK or Cancel button of the dialog
                    this.confirmCallBack = confirmCallback
                    this.cancelCallback = cancelCallback
            
        
        signup: ->
            #The user clicked OK on the modal dialog, call the stored confirm callback with the selected item
            this.result.confirmCallBack()
        
        dismiss: ( type ) ->
            #The user clicked cancel on the modal dialog, call the stored cancel callback
            this.result.cancelCallback( type )
        
      }

      spyOn($modal, 'open').andReturn(fakeModal)

 


      ctrl        = $controller('ModalInstanceCtrl',
                                $scope: scope
                                $modal: modal )
    )

  beforeEach(module("stfmpr"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()


  describe 'create', ->
    newUser =
      first_name: 'John'
      last_name: 'Smith'
      username: 'thing'
      email: 'fake@name.com'
      password: '123456'
      password_confirmation: '123456'
      username: 'Superbad'


    beforeEach ->
      setupController()
      

    it 'posts to the backend', ->
      httpBackend.expectPOST('/users').respond(200)
      scope.open()
      scope.first_name     = newUser.first_name
      scope.last_name      = newUser.last_name
      scope.username       = newUser.user_name
      scope.email          = newUser.first
      scope.password       = newUser.password
      scope.password_confirmation    = newUser.password_confirmation
      scope.modalInstance.dismiss( "cancel" )
      httpBackend.flush()




  
