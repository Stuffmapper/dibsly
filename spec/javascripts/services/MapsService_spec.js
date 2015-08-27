
describe('MapsService', function() {


  var MapsService;
  //Mocking google
  //TODO replace with a better Mocking strategy


  beforeEach(module('stfmpr'));

  var setupController = function(){

    inject(function(_MapsService_){
      // The injector unwraps the underscores (_) from around the parameter names when matchin
      MapsService = _MapsService_;
    });
  };

  describe('Maps Service', function() {
    it('is defined', function() {
      setupController()
      expect(MapsService).toBeDefined();
    });
    it('defines marker functions', function() {
      setupController()
      expect(MapsService.setMapMarker).toBeDefined();
      expect(MapsService.addMarkerListener).toBeDefined();
      expect(MapsService.newMapMarker).toBeDefined();
      expect(MapsService.triggerMarkerEvent).toBeDefined();
      expect(MapsService.newInfoWindow).toBeDefined();
      expect(MapsService.setInfoContent).toBeDefined();
    });

    it('defines misc functions', function() {
      setupController()
      expect(MapsService.newLatLng).toBeDefined();

    });
    it('defines map functions', function() {
      setupController()
      expect(MapsService.addMapListener).toBeDefined();
      expect(MapsService.removeMapListener).toBeDefined();
      expect(MapsService.panTo).toBeDefined();
      expect(MapsService.getCenter).toBeDefined();
      expect(MapsService.setZoom).toBeDefined();

    });

  });
});
