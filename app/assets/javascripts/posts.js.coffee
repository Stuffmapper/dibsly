# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
var _map;
var _newPois;


var drawPins = function() {
        /*
        // Remove markers outside of our maps boundaries.
        if(markers.length > 0){
          removeMarkersOutsideOfMapBounds();
        }

        // Add our new markers to the map (unless they are already on the map.)
        var json = transport.responseText.evalJSON();
        json.each(function(i) {
          id = i.location.id;
          if(!markers[id] || markers[id] == null){
            // Marker doesnt exist, add it.
            markers[id] = createMarker(i.location);
            map.addOverlay(markers[id]);
          }
        });
        */
}

var updateMap = function() {
  var bounds = _map.getBounds();
  if (bounds !== undefined) {
    var northEast = bounds.getNorthEast();
    var southWest = bounds.getSouthWest();

    $.post('/posts/geolocated', {
      'neLat': northEast.lat(),
      'neLng': northEast.lng(),
      'swLat': southWest.lat(),
      'swLng': southWest.lng()
    }).done(function(newPois) {
      _newPois = newPois;
      console.log(_newPois);
      drawPins();
    });
  }
};

function initializeMap() {
  var mapOptions = {
    center: new google.maps.LatLng(47.606163,-122.330818),
    zoom: 8,
    panControl: false,
    zoomControl: false
  };
  _map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  google.maps.event.addListener(_map, 'dragend', function(){updateMap();});
  google.maps.event.addListener(_map, 'zoom_changed', function(){updateMap();});
  google.maps.event.addListenerOnce(_map, 'idle', function(){updateMap();});
};

$(document).on("page:change", function() {
  // we only display the map at first
  $('#main-grid').toggle();
  initializeMap();

  $('#what-stuff-link').click(function() {
    $('#main-grid').toggle();
    $('#map-canvas').toggle();
    return false;
  });
});

`