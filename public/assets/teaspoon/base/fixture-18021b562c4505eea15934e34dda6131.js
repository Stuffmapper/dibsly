(function() {
  var slice = [].slice;

  Teaspoon.fixture = (function() {
    var addContent, cleanup, create, load, loadComplete, preload, putContent, set, xhr, xhrRequest;

    fixture.cache = {};

    fixture.el = null;

    fixture.$el = null;

    fixture.json = [];

    fixture.preload = function() {
      var i, len, results, url, urls;
      urls = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      results = [];
      for (i = 0, len = urls.length; i < len; i++) {
        url = urls[i];
        results.push(preload(url));
      }
      return results;
    };

    fixture.load = function() {
      var append, i, index, j, len, results, url, urls;
      urls = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), append = arguments[i++];
      if (append == null) {
        append = false;
      }
      if (typeof append !== "boolean") {
        urls.push(append);
        append = false;
      }
      results = [];
      for (index = j = 0, len = urls.length; j < len; index = ++j) {
        url = urls[index];
        results.push(load(url, append || index > 0));
      }
      return results;
    };

    fixture.set = function() {
      var append, html, htmls, i, index, j, len, results;
      htmls = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), append = arguments[i++];
      if (append == null) {
        append = false;
      }
      if (typeof append !== "boolean") {
        htmls.push(append);
        append = false;
      }
      results = [];
      for (index = j = 0, len = htmls.length; j < len; index = ++j) {
        html = htmls[index];
        results.push(set(html, append || index > 0));
      }
      return results;
    };

    fixture.cleanup = function() {
      return cleanup();
    };

    function fixture() {
      Teaspoon.fixture.load.apply(window, arguments);
    }

    xhr = null;

    preload = function(url) {
      return load(url, false, true);
    };

    load = function(url, append, preload) {
      var cached, value;
      if (preload == null) {
        preload = false;
      }
      if (cached = Teaspoon.fixture.cache[url]) {
        return loadComplete(url, cached.type, cached.content, append, preload);
      }
      value = null;
      xhrRequest(url, function() {
        if (xhr.readyState !== 4) {
          return;
        }
        if (xhr.status !== 200) {
          throw "Unable to load fixture \"" + url + "\".";
        }
        return value = loadComplete(url, xhr.getResponseHeader("content-type"), xhr.responseText, append, preload);
      });
      return value;
    };

    loadComplete = function(url, type, content, append, preload) {
      Teaspoon.fixture.cache[url] = {
        type: type,
        content: content
      };
      if (type.match(/application\/json;/)) {
        return fixture.json[fixture.json.push(JSON.parse(content)) - 1];
      }
      if (preload) {
        return content;
      }
      if (append) {
        addContent(content);
      } else {
        putContent(content);
      }
      return Teaspoon.fixture.el;
    };

    set = function(content, append) {
      if (append) {
        return addContent(content);
      } else {
        return putContent(content);
      }
    };

    putContent = function(content) {
      cleanup();
      create();
      return Teaspoon.fixture.el.innerHTML = content;
    };

    addContent = function(content) {
      if (!Teaspoon.fixture.el) {
        create();
      }
      return Teaspoon.fixture.el.innerHTML += content;
    };

    create = function() {
      var ref;
      Teaspoon.fixture.el = document.createElement("div");
      if (typeof window.$ === 'function') {
        Teaspoon.fixture.$el = $(Teaspoon.fixture.el);
      }
      Teaspoon.fixture.el.id = "teaspoon-fixtures";
      return (ref = document.body) != null ? ref.appendChild(Teaspoon.fixture.el) : void 0;
    };

    cleanup = function() {
      var base, ref, ref1;
      (base = Teaspoon.fixture).el || (base.el = document.getElementById("teaspoon-fixtures"));
      if ((ref = Teaspoon.fixture.el) != null) {
        if ((ref1 = ref.parentNode) != null) {
          ref1.removeChild(Teaspoon.fixture.el);
        }
      }
      return Teaspoon.fixture.el = null;
    };

    xhrRequest = function(url, callback) {
      var e;
      if (window.XMLHttpRequest) {
        xhr = new XMLHttpRequest();
      } else if (window.ActiveXObject) {
        try {
          xhr = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (_error) {
          e = _error;
          try {
            xhr = new ActiveXObject("Microsoft.XMLHTTP");
          } catch (_error) {
            e = _error;
          }
        }
      }
      if (!xhr) {
        throw "Unable to make Ajax Request";
      }
      xhr.onreadystatechange = callback;
      xhr.open("GET", Teaspoon.root + "/fixtures/" + url, false);
      return xhr.send();
    };

    return fixture;

  })();

}).call(this);
