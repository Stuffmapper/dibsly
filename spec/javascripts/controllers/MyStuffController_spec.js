
describe('MyStuffCtrl', function() {


  var controller,
  httpBackend,
  gmarker,
  google,
  mockUserService,
  mockMarkerService,
  routeParams,
  $q,
  $rootScope,
  $scope,
  UserService;




  var setupController = function(){
    module('stfmpr');

    inject(function(_$controller_,_$q_, _$rootScope_, _$httpBackend_, _$routeParams_, UserService, MarkerService){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      $controller = _$controller_;
      $q = _$q_;
      $rootScope = _$rootScope_;
      $scope = $rootScope.$new();
      $routeParams = _$routeParams_;
      httpBackend = _$httpBackend_;
      spyOn(UserService,"check").and.returnValue( UserService.currentUser = 'Jack');
      $scope.currentUser = 'Jack';
      gmarker = jasmine.createSpyObj('gmarker',['setIcon']);
      $scope.markers = {
       1:{dibber:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker },
       2:{dibber:'Jack', updated_at: new Date('2014-11-22'), marker: gmarker},
       3:{dibber: 'john', creator:'Jack', updated_at: new Date('2012-11-24'), marker: gmarker },
       4:{dibber:'Jackie', creator:'Jack', updated_at: new Date('2012-11-25'), marker: gmarker},
       5:{dibber:'Jack', updated_at: new Date('2014-11-23'), marker: gmarker },
       6:{ marker:gmarker}
      };

      MarkerService.markers = $scope.markers;
      controller = $controller('MyStuffCtrl', { $scope: $scope });
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
      expect(dibs[0]).toBe(  $scope.markers[5]);
      expect(dibs[1]).toBe(  $scope.markers[2]);
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
      expect(posts[0]).toBe(  $scope.markers[4]);
      expect(posts[1]).toBe(  $scope.markers[3]);
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
