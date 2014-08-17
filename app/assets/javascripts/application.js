// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks

var map;
var pois = [];
var markers = [];
var infowindowClosed = true;
var infoWindows = [];
var presets = {};
presets['latitude'] = 47.606163;
presets['longitude'] = -122.330818;
presets['zoom'] = 8;

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
        for (var i=0;i<infoWindows.length;i++) {
            infoWindows[i].close();
            infoWindows = [];
        }
        infowindowClosed = false;
        infoWindow = new google.maps.InfoWindow({
            content: poi.description+'<br><img src="'+poi.image_url+'" /><br>'+poi.dibbed_until+'<br><a rel="nofollow" href="/posts/'+poi.id+'/dib" data-method="dib">Dib</a>'
        })
        infoWindow.open(map,marker);
        infoWindows.push(infoWindow);
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
                'zoom': map.getZoom(),
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
        center: new google.maps.LatLng(presets['latitude'],presets['longitude']),
        zoom: presets['zoom'],
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
        zoomControl: false,

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
    $.ajax({
        url: '/presets',
        type: "POST",
        dataType: "json",
        async:false
    }).done(function(data){
        if(data['grid_mode']) {
            $('#map-canvas').hide();
        } else {
            $('#main-grid').hide();
        }

        if (data['latitude'] !== undefined) {
            presets['latitude'] = data['latitude'];
            presets['longitude'] = data['longitude'];
            presets['zoom'] = data['zoom'];
        }
    })

    // we only display the map at first
    $('#flash-message').hide();
    $('#give-stuff-dialog').hide();
    $('#my-stuff-dialog').hide();
    $('#sign-up-dialog').hide();
    $('#log-in-dialog').hide()
    $('#more-stuff-dialog').hide();;
    $('#messages-dialog').hide();
    $('#messages-new').hide();

    initializeMap();

    $('#search-form').submit(function(event) {
        if (!$('#main-grid').is(":visible")) {
            event.preventDefault();
            updateMap();

        }
    });

    $('form#new-user').submit(function(event) {
        event.preventDefault();

    });

    $('#sign-up-form').submit(function(event) {
        event.preventDefault();

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
        }).done(function(){
            window.location.href = "/";
        }).fail(function(jqXHR, b, c) {
            Recaptcha.reload();
            var errorMessage = "";
            $.each(jqXHR.responseJSON, function(keyArray, valueArray) {
                var fieldName = keyArray.replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                $.each(valueArray, function(key, value) {
                    errorMessage = errorMessage + fieldName+' '+value+'.<br>';
                });
            });
            $('#sign-up-form-errors').html(errorMessage);
            window.scrollTo(0, 0);
        });
        return false;

    });

    $('#sign-up').click(function() {
        Recaptcha.reload();
        $('#sign-up-dialog').dialog({modal: true});
        return false;
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
            $('#log-in-form-errors').text('Invalid name or password.');
        });
        return false;

    });

    $('#log-in').click(function() {
        $('#log-in-dialog').dialog({modal: true});
        return false;
    });

    $('#new-message-form').submit(function(event) {
        event.preventDefault();

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
        }).done(function(){
            $('#new-message-form').get(0).reset();
            $('#messages-new').hide();
            $('#messages-dialog').dialog("close");
        }).fail(function() {
            $('#new-message-form-errors').text('Invalid message.');
        });
        return false;

    });

    $('#messages-inbox').on('click', '.answer-link', function() {
        $('#receiver-name').text($(this).attr('sender-name'));
        $('#message_receiver_id').val($(this).attr('sender-id'));
        $('#messages-new').show();
        return false;
    });

    $('#messages-link').click(function() {
        $.ajax({
            url: '/messages',
            type: "GET",
            dataType: "json",
        }).done(function(messages){
            var inbox = '';
            $.each(messages, function(index, message) {
                inbox = inbox + '<div>From '+message.sender_name+'<br>'+message.content+'<br><a href="#" class="answer-link" sender-id="'+message.sender_id+'" sender-name="'+message.sender_name+'" >Answer</a></div>'
            });
            $('#messages-inbox').html(inbox);
            $('#messages-dialog').dialog({modal: true});
        }).fail(function() {
            console.log('error');
        });
        return false;
    });

    $('#find-stuff').click(function() {
        $('#map-canvas').show();
        $('#main-grid').hide();
        $.ajax({
            url: '/posts/grid_mode?grid_mode=false',
            type: "POST",
            dataType: "json",
        });
        return false;
    });

    $('#what-stuff').click(function() {
        $('#map-canvas').hide();
        $('#main-grid').show();
        $.ajax({
            url: '/posts/grid_mode?grid_mode=true',
            type: "POST",
            dataType: "json",
        });
        return false;
    });

    $("#post_image").change(function () {
        if (this.files && this.files[0]) {
            var FR = new FileReader();
            FR.onload = function (e) {
                $("#post_image_url").val(e.target.result);
            };
            FR.readAsDataURL(this.files[0]);
        }
    });

    $('#give-stuff-form').submit(function(event) {
        event.preventDefault();

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json"
        }).done(function(){
            updateMap();
            $('#give-stuff-form').get(0).reset();
            $('#give-stuff-dialog').dialog("close");
            $("#flash-message-span").text('Congrats on your Stuffmapper listing!');
            $("#flash-message").show().delay(5000).fadeOut();
        }).fail(function(jqXHR, b, c) {
            var errorMessage = "";
            $.each(jqXHR.responseJSON, function(keyArray, valueArray) {
                var fieldName = keyArray.replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                $.each(valueArray, function(key, value) {
                    errorMessage = errorMessage + fieldName+' '+value+'.<br>';
                });
            });
            $('#give-stuff-form-errors').html(errorMessage);
            window.scrollTo(0, 0);
        });
        return false;
    });

    $('#give-stuff').click(function() {
        $('#give-stuff-dialog').dialog({modal: true, dialogClass: "give-stuff-dialog-style"});
        $('#phone-number-field').hide();
        initializeMiniMap();
        return false;
    });

    $('#my-stuff-form').submit(function(event) {
        event.preventDefault();

        $.ajax({
            url: $(this).attr('action'),
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
        }).done(function(){
            window.location.href = "/";
        }).fail(function(jqXHR, b, c) {
            var errorMessage = "";
            $.each(jqXHR.responseJSON, function(keyArray, valueArray) {
                var fieldName = keyArray.replace(/\b[a-z]/g, function(letter) {
                    return letter.toUpperCase();
                });
                $.each(valueArray, function(key, value) {
                    errorMessage = errorMessage + fieldName+' '+value+'.<br>';
                });
            });
            $('#my-stuff-form-errors').html(errorMessage);
            window.scrollTo(0, 0);
        });
        return false;

    });

    $('#my-stuff').click(function() {
        $('#my-stuff-dialog').dialog({modal: true, dialogClass: "my-stuff-dialog-style"});
        return false;
    });

    $('#post_on_the_curb_false').click(function() {
        $('#phone-number-field').show();
        return true;
    });

    $('#post_on_the_curb_true').click(function() {
        $('#phone-number-field').hide();
        return true;
    });

    $('#more-stuff').click(function() {
        $('#more-stuff-dialog').dialog({modal: true});
        return false;
    });
}

$(document).ready(ready);
$(document).on('page:load', ready);