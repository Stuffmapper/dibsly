# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
var map;
var pois = [];
var markers = [];
var infowindowClosed = true;

// for the map

var clearMarkers =function() {
  $.each(markers, function(key, marker) {
    if (marker !== undefined) {
      marker.setMap(null);
    }
  });
  markers = [];
}

var createMarker = function(poi) {
  var infoWindow;
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(poi.latitude,poi.longitude),
    map: map,
    title: poi.title
  });
  google.maps.event.addListener(marker, 'click', function() {
    infowindowClosed = false;
    infoWindow = new google.maps.InfoWindow({
      content: poi.description+'<br><img src="'+poi.image_url+'" /><br>'+poi.dibbed_until+'<br><a rel="nofollow" href="/posts/'+poi.id+'/dib" data-method="dib">Dib</a>'
    })
    infoWindow.open(map,marker);
    google.maps.event.addListener(infoWindow,'closeclick',function(){
      infowindowClosed = true;
    });
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
if (infowindowClosed) {
    var bounds = map.getBounds();
    if (bounds !== undefined) {
      var northEast = bounds.getNorthEast();
      var southWest = bounds.getSouthWest();

      $.post('/posts/geolocated', {
        'neLat': northEast.lat(),
        'neLng': northEast.lng(),
        'swLat': southWest.lat(),
        'swLng': southWest.lng(),
        'term': $('#city-term').val()
      }).done(function(newPois) {
        if (!(JSON.stringify(pois)==JSON.stringify(newPois))) {
          pois = newPois;
          renderPois();
        }
      });
    }
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

// for the minimap

var geocoder;
var minimap;
var minimapLatLng;
var minimapMarker;

var geocodePosition = function(pos) {
  geocoder.geocode({
    latLng: pos
  }, function(responses) {
    if (responses && responses.length > 0) {
      updateAddress(responses[0].formatted_address);
    } else {
      updateAddress('Cannot determine address at this position');
    }
  });
}

var updateMarkerPosition = function(latLng) {
  minimapMarker.setPosition(latLng);
  $('#post_latitude').val(latLng.lat());
  $('#post_longitude').val(latLng.lng());
}

var updateAddress = function(address) {
  $('#post_address').val(address);
}

function initializeMiniMap() {
  minimapLatLng = new google.maps.LatLng(map.getCenter().lat(),map.getCenter().lng());

  var minimapOptions = {
    center: minimapLatLng,
    zoom: map.getZoom(),
    panControl: false,
    zoomControl: false
  };
  minimap = new google.maps.Map(document.getElementById("minimap-canvas"), minimapOptions);
  geocoder = new google.maps.Geocoder();

  minimapMarker = new google.maps.Marker({
    title: 'Position',
    map: minimap
  });

  google.maps.event.addListener(minimap, 'click', function(event) {
    updateMarkerPosition(event.latLng);
    geocodePosition(event.latLng);
  });
}

// everything else

var ready = function() {
  // we only display the map at first
  $('#main-grid').hide();
  $('#give-stuff-dialog').hide();
  $('#my-stuff-dialog').hide();
  $('#sign-up-dialog').hide();
  $('#log-in-dialog').hide();

  initializeMap();

  $('#search-form').submit(function(event) {
    event.preventDefault();
    updateMap();
  });

  $('#sign-up').click(function() {
    $('#sign-up-dialog').dialog({modal: true});
    return false;
  });

  $('form#new-user').submit(function(event) {
    event.preventDefault();

  });

  $('#log-in-form').submit(function(event) {
    event.preventDefault();

    $.ajax({
      url: $(this).attr('action'),
      type: "POST",
      data: $(this).serialize(),
      dataType: "json",
    }).done(function(){
      window.location.href = "/";
    }).fail(function() {
      $('#log-in-form-errors').text('Invalid email or password.');
    });
    return false;

  });

  $('#log-in').click(function() {
    $('#log-in-dialog').dialog({modal: true});
    return false;
  });

  $('#find-stuff').click(function() {
    $('#map-canvas').show();
    $('#main-grid').hide();
    return false;
  });

  $('#what-stuff').click(function() {
    $('#map-canvas').hide();
    $('#main-grid').show();
    return false;
  });

  $('#give-stuff').click(function() {
    $('#give-stuff-dialog').dialog({modal: true});
    initializeMiniMap();
    return false;
  });

  $('#my-stuff').click(function() {
    $('#my-stuff-dialog').dialog({modal: true});
    return false;
  });

  $('#post_on_the_curb_false').click(function() {
    $('#phone-number-field').hide();
    return true;
  });

  $('#post_on_the_curb_true').click(function() {
    $('#phone-number-field').show();
    return true;
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
`