
describe('MyStuffCtrl', function() {
  beforeEach(module('stfmpr'));

  var $controller;

  beforeEach(inject(function(_$controller_){
    // The injector unwraps the underscores (_) from around the parameter names when matching
    $controller = _$controller_;
  }));

  describe('showtab', function() {
    it('changes the tabs correctly ', function() {
      var $scope = {};
      var controller = $controller('MyStuffCtrl', { $scope: $scope });
      $scope.tabs = {posts: true, messages: false, profile: false};
      showtab('messages');
      expect($scope.tabs.messages).toEqual(true);
    });
  });
});
