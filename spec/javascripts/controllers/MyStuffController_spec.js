
describe('MyStuffCtrl', function() {


  var controller,
  $httpBackend,
  gmap,
  gmarker,
  google,
  markers,
  mockUserService,
  mockMarkerService,
  mockMapsService,
  routeParams,
  $q,
  $rootScope,
  $scope,
  UserService;




  var setupController = function(){
    module('stfmpr');

    inject(function(_$controller_,_$q_, _$rootScope_, _$httpBackend_, _$routeParams_, UserService, MarkerService, MapsService){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      $controller = _$controller_;
      $q = _$q_;
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $routeParams = _$routeParams_;
      $httpBackend = _$httpBackend_;
      mockMapsService = MapsService;
      mockMarkerService = MarkerService;
      spyOn(UserService,"check").and.returnValue( UserService.currentUser = 'Jack');
      gmarker = jasmine.createSpyObj('gmarker',['setIcon', 'setMap' ]);
      gmap = jasmine.createSpyObj('gmap',['panTo' ]);
      $scope.currentUser = 'Jack';
      markers = [
       { id:1, dibber:'Jack', updated_at: new Date('2012-11-25') },
       { id:2, dibber:'Jack', updated_at: new Date('2014-11-22') },
       { id:3, dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24') },
       { id:4,dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25') },
       { id:5, dibber:'Jack', updated_at: new Date('2014-11-23') },
       { id:6, marker:gmarker}
      ];
      spyOn(mockMapsService,'loadMap').and.returnValue( $q( function(resolve, reject){ resolve(gmap); }) ) 
      spyOn(mockMapsService,'newMapMarker').and.returnValue( $q( function(resolve, reject){ resolve(gmarker); }) ) 
      spyOn(mockMapsService,'addMarkerListener').and.returnValue( true )
      angular.forEach(markers, function(marker){
        mockMarkerService.setMarker(marker)
      });
      $rootScope.$digest();
      $controller = $controller('MyStuffCtrl', { $scope: $scope });
    });


  };


  describe('showtab', function() {
    it('changes the tabs correctly ', function() {
      setupController();
      $scope.tabs = {posts: true, messages: false, profile: false};
      $scope.showtab('messages');
      expect($scope.tabs.messages).toEqual(true);
      expect($scope.tabs.posts).toEqual(false);
    });
  });

  describe('show dibs', function() {
    it('returns the markers that have been dibbed', function() {
      setupController();
      var dibs = $scope.show('dibber');

      expect(dibs[0].id ).toBe( markers[4].id);
      expect(dibs[1].id ).toBe( markers[1].id );
      expect(dibs.length).toEqual(3);
    });

    it('returns the 0 if there ia no currentUser', function() {
      setupController();
      $scope.currentUser = false;
      var dibs = $scope.show('dibber');
      expect(dibs.length).toEqual(0);
    });
    it('resets an icon the if there is a currentUser', function() {
      setupController();
      $scope.currentUser = 'Jack';
      var dibs = $scope.show('dibber');
      expect(gmarker.setIcon).toHaveBeenCalled();
    });
    it('does not reset an icon without a currentUser', function() {
      setupController();
      $scope.currentUser = false;
      var dibs = $scope.show('dibber');
      expect(dibs.length).toEqual(0);
      expect(gmarker.setIcon).not.toHaveBeenCalled();
    });
  });

  describe('show posts', function() {
    it('returns the markers that have been posted', function() {
      setupController();
      $scope.currentUser = 'Jack'
      var posts = $scope.show('creator');
      expect(posts[0].id ).toEqual( markers[3].id );
      expect(posts[1].id  ).toBe( markers[2].id );
      expect(posts.length).toEqual(2);
    });
    it('returns the 0 if there ia no currentUser', function() {
      setupController();
      $scope.currentUser = false;
      var dibs = $scope.show('creator');
      expect(dibs.length).toEqual(0);
    });
    it('resets an icon the if there is a currentUser', function() {
      setupController();
      $scope.currentUser = 'Jack';
      var posts = $scope.show('creator');
      expect(gmarker.setIcon).toHaveBeenCalled();
    });
    it('does not reset an icon without a currentUser', function() {
      setupController();
      $scope.currentUser = undefined;
      var posts = $scope.show('creator');
      expect(posts.length).toEqual(0);
      expect(gmarker.setIcon).not.toHaveBeenCalled();
    });
  });
});
