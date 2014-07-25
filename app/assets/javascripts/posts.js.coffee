# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
var map;
var pois = [];
var markers = [];


var clearMarkers =function() {
  $.each(markers, function(key, marker) {
    if (marker !== undefined) {
      marker.setMap(null);
    }
  });
  markers = [];
}

var createMarker = function(poi) {
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(poi.latitude,poi.longitude),
    map: map,
    title: poi.title
  });
  google.maps.event.addListener(marker, 'click', function() {
    new google.maps.InfoWindow({
      content: poi.description+'<br>'+poi.dibbed_until+'<br><a rel="nofollow" href="/posts/'+poi.id+'/dib" data-method="dib">Dib</a>'
    }).open(map,marker);
  });
  return marker;
}

var renderPois = function() {
  if(markers.length > 0){
    clearMarkers();
  }

  for (var i = 0; i < pois.length; i++) {
    var id = pois[i].id;
    markers[id] = createMarker(pois[i]);
  }
}

var updateMap = function() {
  var bounds = map.getBounds();
  if (bounds !== undefined) {
    var northEast = bounds.getNorthEast();
    var southWest = bounds.getSouthWest();

    $.post('/posts/geolocated', {
      'neLat': northEast.lat(),
      'neLng': northEast.lng(),
      'swLat': southWest.lat(),
      'swLng': southWest.lng()
    }).done(function(newPois) {
      if (!(JSON.stringify(pois)==JSON.stringify(newPois))) {
        pois = newPois;
        renderPois();
      }
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
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  google.maps.event.addListener(map, 'dragend', function(){updateMap();});
  google.maps.event.addListener(map, 'zoom_changed', function(){updateMap();});
  google.maps.event.addListener(map, 'idle', function(){updateMap();});
};

var ready = function() {
  // we only display the map at first, not the grid
  $('#main-grid').toggle();
  initializeMap();

  $('#what-stuff-link').click(function() {
    //pois = [];
    $('#main-grid').toggle();
    $('#map-canvas').toggle();
    return false;
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
`