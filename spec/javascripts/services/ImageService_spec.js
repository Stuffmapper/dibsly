
describe('ImageService', function() {


  var ImageService, gmarker, markers;
  //Mocking google
  //TODO replace with a better Mocking strategy


  beforeEach(module('stfmpr'));

  var setupController = function(){

    inject(function(_ImageService_){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      ImageService = _ImageService_;
    });

  };



  describe('Marker Service', function() {
    it('is defined', function() {
      setupController();
      expect(MarkerService).toBeDefined();
    });
  });

  describe('setMarker ', function() {
    it('sets a Marker', function() {
      setupController();
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(markers[1])
      expect(MarkerService.markers[1].updated_at ).toEqual(markers[1].updated_at );
    });
    it('extends a Marker', function() {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.markers[1].id).toEqual(info.id);
      MarkerService.setMarker(newinfo);
      expect(MarkerService.markers[1].url).toEqual(info.url);
      expect(MarkerService.markers[1].url_image).toEqual(newinfo.url_image);
    });

    it('creates a marker ', function() {
      setupController();
      var info = {id:1, url: 'this is a url'}
      var newinfo = {id:1, url_image: 'this is a url'}
      expect(MarkerService.markers[1]).toBeUndefined();
      MarkerService.setMarker(info);
      expect(MarkerService.markers[1].id).toEqual(info.id);
      MarkerService.setMarker(newinfo);
      expect(MarkerService.markers[1].marker).not.toBeUndefined();
    });


  });
});
