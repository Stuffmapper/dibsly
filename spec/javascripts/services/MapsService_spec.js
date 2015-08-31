
describe('MapsService', function() {


  var MapsService;
  //NOTE calls to google are not being tested
  //this is mainly a wrapper


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

  describe('getBoundingBox', function() {
    it('is defined', function() {
      setupController()
      expect(MapsService.getBoundingBox).toBeDefined();
    });

    it('returns a box', function() {
      setupController()
      var coords = {lat:47, lon: -122 };
      //Note accurate?
      //distance in miles
      expect(MapsService.getBoundingBox(coords, 10)).toEqual({
        nw:{ lat: 47.10223626958386, lon: -122.15033889231952 },
        se: { lat: 46.89756772513648, lon: -121.85023590256421 }
       });

    });
    it('returns the existing box if point within existing box', function() {
      setupController()
      MapsService.boundingBox = {
        nw:{ lat: 47.10223626958386, lon: -122.15033889231952 },
        se: { lat: 46.89756772513648, lon: -121.85023590256421 }
      };
      var coords = {lat:46.9, lon: -121.9 };

      expect(MapsService.getBoundingBox(coords, 10)).toEqual({
        nw:{ lat: 47.10223626958386, lon: -122.15033889231952 },
        se: { lat: 46.89756772513648, lon: -121.85023590256421 }
       });
     });

  });
});
