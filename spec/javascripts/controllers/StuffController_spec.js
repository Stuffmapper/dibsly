
describe('StuffCtrl', function() {


  var controller,
  authHandler,
  $httpBackend,
  $location,
  gmarker,
  LocationService,
  mockLocalService,
  mockMapsService,
  MarkerService,
  mockMarkerService,
  $routeParams,
  $q,
  $rootScope,
  $timeout,
  $scope,
  UserService;
  window.google = { 
    load: function(){ }// todo ..beter mocking
  };

  var setupController = function(){
    module('stfmpr');

    inject(function(_$controller_,_$q_, _$rootScope_, _$httpBackend_,
       _$location_, _$routeParams_,_$timeout_, LocalService, LocationService, UserService,
        MarkerService, MapsService){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      $controller = _$controller_;
      $location = _$location_;
      $q = _$q_;
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $routeParams = _$routeParams_;
      $httpBackend = _$httpBackend_;
      mockLocalService = LocalService;
      LocationService = LocationService;
      $scope.currentUser = 'Jack';
      $scope.map = jasmine.createSpyObj('map',['new', 'panTo']);
      $timeout = _$timeout_;
      gmarker = jasmine.createSpyObj('gmarker',['setIcon', 'setMap', 'getPosition']);
      // //TODO make this work

      //
      authHandler = $httpBackend.whenGET( /\/api\/posts\/geolocated.*/ )
      authHandler.respond({ posts: [
                                {id:1, dibber:'Jack', updated_at:'2012-11-25' },
                                {id:2, dibber:'Jack', updated_at: '2014-11-22'},
                                {id:3, dibber: 'john', creator:'Jack', updated_at: '2012-11-24'},
                                {id:4, dibber:'Jackie', creator:'Jack', updated_at:'2012-11-25'},
                                {id:5, dibber:'Jack', updated_at:'2014-11-23' }
                            ]
                           });

      // var markers = {
      //  1:{dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
      //  2:{dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker},
      //  3:{dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
      //  4:{dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
      //  5:{dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker },
      //  6:{ marker:gmarker}
      // };
      // MarkerService.markers = markers;
      var fakeCoords = function(){ return $q.when({ lat:1, lng:2 } ) };
      mockMarkerService = MarkerService;
      mockMapsService = MapsService;
      spyOn(mockMapsService, 'newLatLng').and.returnValue('none')
      spyOn(mockLocalService, 'get').and.returnValue(undefined)
      spyOn(mockMapsService, 'panTo').and.returnValue( $q.when({}) )
      spyOn(mockMapsService, 'getCenter').and.callFake(fakeCoords)
      spyOn(mockMapsService, 'getPosition').and.returnValue( { lat:1, lng:2 } );
      spyOn(mockMapsService, 'newMapMarker').and.returnValue( $q.when(gmarker) )
      spyOn(mockMapsService, 'resizeMap').and.returnValue($q.when({}));
      spyOn(mockMapsService, 'setMapMarker').and.returnValue($q.when({}));
      spyOn(mockMapsService, 'addMapListener').and.returnValue(true);
      spyOn(mockMapsService, 'addMarkerListener').and.returnValue( $q.when() )
      controller = $controller('StuffCtrl', { $scope: $scope });

    });


  };

  describe('center map', function() {
    beforeEach(function(done) {
      done();
    }, 4000);


    it('calls map service center function without navigator', function(done) {
      setupController();
      //MapsService =
      $scope.centerMap()
      .then( function(data){
        expect(mockMapsService.getCenter ).toHaveBeenCalled();
        done();

      })
      $rootScope.$digest();
      //needed for promises to resolve

    });

    it('sets map to the User Location when there is a navigator', function(done) {
      setupController();
       window.navigator = { geolocation: {
          getCurrentPosition: function(success, error, geoOptions){
             success({
               coords: { latitude:1, longitude: 3 }
             })
          }
        }
      };
      $scope.centerMap()
      .then( function(data){
        expect( mockMapsService.getCenter ).toHaveBeenCalled();
        done();
      })
      $rootScope.$digest();
      //needed for promises to resolve
    });


  });

  describe('giveStuff', function() {
    it('opens up Give Stuff when in the routeParams ', function() {
      setupController();
      controller = $controller('StuffCtrl', {
        $scope: $scope,
        $routeParams: { menuState: 'giveStuff'}
      });
      expect($scope.tabs.giveStuff[0] ).toEqual(true)

    });
    it('calls clearMarkers', function(done) {
      setupController();
      spyOn( mockMarkerService, 'clearMarkers').and.returnValue($q.when())
      spyOn($scope, 'giveStuff').and.callThrough();
      expect(mockMarkerService.clearMarkers).not.toHaveBeenCalledWith('giveStuff');
      $scope.giveStuff()
      .then(function(){
        expect(mockMarkerService.clearMarkers).toHaveBeenCalledWith('giveStuff');
        done();
      });
      $rootScope.$digest();
    });
    it('sets the routeParams', function(done) {
      setupController();
      spyOn($scope, 'giveNext' ).and.callThrough();
      expect( $location.url() ).toEqual('/menu/getStuff?tab=gs')
      $scope.giveStuff()
      .then( function(){
        expect($scope.giveNext).toHaveBeenCalled();
        expect($location.url() ).toEqual('/menu/giveStuff/1?gsp=1')
        done();
      });
      $rootScope.$digest()

    });

    it('adds a Marker Listener', function(done) {
      setupController();
      mockMapsService.addMarkerListener.calls.reset();
      expect(mockMapsService.addMarkerListener).not.toHaveBeenCalled()
      $scope.giveStuff()
      .then(function(){
        var marker = mockMarkerService.markers.giveStuff;
        var lastCallArgs = mockMapsService.addMarkerListener.calls.mostRecent().args;
        expect(lastCallArgs[1]).toEqual('dragend')
        expect(lastCallArgs[0]).toEqual(gmarker)
        done();
      })
       $rootScope.$digest();
    });

    it('sets the classes for the map and menu', function(done) {
      setupController();
      expect($scope.mapHeight).toEqual('map-0');
      expect($scope.menuHeight).toEqual('menu-0');
      $scope.giveStuff()
      .then(function(){
        expect($scope.mapHeight).toEqual('map-1-1');
        expect($scope.menuHeight).toEqual('menu-1-1');
        done();
      })
      $rootScope.$digest();
    });
  });

  describe('markers', function() {
    it('is defined', function() {
      setupController()
      expect($scope.markers).toBeDefined();
    });
    it('sets the classes for the map and menu', function() {
      setupController();
      spyOn(mockMarkerService, 'where');
      $scope.markers({visible:true})

      expect(mockMarkerService.where).toHaveBeenCalled();

    });
  });
  describe('mapChanged event', function() {
    it('activates the updateMarkers', function() {
      setupController();
      spyOn($scope, 'updateMarkers');
      $scope.$emit('mapChanged', {nw:{lat:1, lon:2},se:{lat:1, lon:2}});
      expect($scope.updateMarkers).toHaveBeenCalled();
      //TODO fix this as it may be a false positive
      //update Markers is called on setup

    });
  });


 describe('getStuff', function() {
    it('sets all the markers to the map', function(done) {

      setupController();

      $scope.getStuff()
      $httpBackend.flush();

      $rootScope.$digest();
      expect(5).toEqual($scope.mapped.length);
      expect(mockMapsService.newMapMarker.calls.count()).toEqual(5);
      done();
      
    
    });
    it('sets the menu and map height', function() {
      setupController();
      $scope.getStuff();

      $httpBackend.flush();
      $rootScope.$digest();

      expect($scope.mapHeight).toEqual('map-0');
      expect($scope.menuHeight).toEqual('menu-0');
      expect(mockMapsService.setMapMarker ).toHaveBeenCalled();
    });
  });
  //TODO -mock httpBackend for mystuff and flush
  // describe('My Stuff', function() {
  //   it('sets all the markers to the map', function() {
  //     setupController();
  //     spyOn(mockMapsService, 'setMapMarker').and.returnValue('none');
  //     $scope.myStuff();
      
  //     expect(mockMapsService.setMapMarker ).toHaveBeenCalled();

  //   });
  // });



});
