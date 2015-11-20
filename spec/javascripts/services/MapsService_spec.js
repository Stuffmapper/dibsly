
describe('MapsService', function() {


  var MapsService;
  //NOTE calls to google are not being tested
  //this is mainly a wrapper


  beforeEach(module('stfmpr'));

  var setupController = function(){
    window.google = { 
   load: function(){ }// todo ..beter mocking
  };

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
      expect(MapsService.removeMapListeners).toBeDefined();
      expect(MapsService.getPosition).toBeDefined();
      expect(MapsService.panTo).toBeDefined();
      expect(MapsService.panToMarker).toBeDefined();
      expect(MapsService.resizeMap).toBeDefined();
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
      var coords = {lat:47, lng: -122 };
      //Note accurate?
      //distance in miles
      expect(MapsService.getBoundingBox(coords, 10)).toEqual({
        nw:{ lat: 47.10223626958386, lng: -122.15033889231952 },
        se: { lat: 46.89756772513648, lng: -121.85023590256421 }
       });

    });
    it('returns the existing box if point within existing box', function() {
      setupController()
      MapsService.setBoundingBox({
        nw:{ lat: 47.10223626958386, lng: -122.15033889231952 },
        se: { lat: 46.89756772513648, lng: -121.85023590256421 }
      });
      var coords = {lat:46.9, lng: -121.9 };

      expect(MapsService.getBoundingBox(coords, 10)).toEqual({
        nw:{ lat: 47.10223626958386, lng: -122.15033889231952 },
        se: { lat: 46.89756772513648, lng: -121.85023590256421 }
       });
     });

  });
});

  // Failure/Error: Expected Object({ nw: Object({ lat: 47.00223661318345, lng: -122.05005726202955 }), se: Object({ lat: 46.79756806611827, lng: -121.75051445612024 }) }) 
  // to equal Object({ nw: Object({ lat: 47.10223626958386, lng: -122.15033889231952 }), se: Object({ lat: 46.89756772513648, lng: -121.85023590256421 }) }).
