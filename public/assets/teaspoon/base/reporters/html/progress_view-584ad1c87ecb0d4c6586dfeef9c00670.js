(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Teaspoon.Reporters.HTML.ProgressView = (function(superClass) {
    extend(ProgressView, superClass);

    function ProgressView() {
      return ProgressView.__super__.constructor.apply(this, arguments);
    }

    ProgressView.create = function(displayProgress) {
      if (displayProgress == null) {
        displayProgress = true;
      }
      if (!displayProgress) {
        return new Teaspoon.Reporters.HTML.ProgressView();
      }
      if (Teaspoon.Reporters.HTML.RadialProgressView.supported) {
        return new Teaspoon.Reporters.HTML.RadialProgressView();
      } else {
        return new Teaspoon.Reporters.HTML.SimpleProgressView();
      }
    };

    ProgressView.prototype.build = function() {
      return this.el = this.createEl("div", "teaspoon-indicator teaspoon-logo");
    };

    ProgressView.prototype.update = function() {};

    return ProgressView;

  })(Teaspoon.Reporters.BaseView);

  Teaspoon.Reporters.HTML.SimpleProgressView = (function(superClass) {
    extend(SimpleProgressView, superClass);

    function SimpleProgressView() {
      return SimpleProgressView.__super__.constructor.apply(this, arguments);
    }

    SimpleProgressView.prototype.build = function() {
      this.el = this.createEl("div", "simple-progress");
      return this.el.innerHTML = "<em id=\"teaspoon-progress-percent\">0%</em>\n<span id=\"teaspoon-progress-span\" class=\"teaspoon-indicator\"></span>";
    };

    SimpleProgressView.prototype.update = function(total, run) {
      var percent;
      percent = total ? Math.ceil((run * 100) / total) : 0;
      return this.setHtml("progress-percent", percent + "%");
    };

    return SimpleProgressView;

  })(Teaspoon.Reporters.HTML.ProgressView);

  Teaspoon.Reporters.HTML.RadialProgressView = (function(superClass) {
    extend(RadialProgressView, superClass);

    function RadialProgressView() {
      return RadialProgressView.__super__.constructor.apply(this, arguments);
    }

    RadialProgressView.supported = !!document.createElement("canvas").getContext;

    RadialProgressView.prototype.build = function() {
      this.el = this.createEl("div", "teaspoon-indicator radial-progress");
      return this.el.innerHTML = "<canvas id=\"teaspoon-progress-canvas\"></canvas>\n<em id=\"teaspoon-progress-percent\">0%</em>";
    };

    RadialProgressView.prototype.appendTo = function() {
      var canvas, e;
      RadialProgressView.__super__.appendTo.apply(this, arguments);
      this.size = 80;
      try {
        canvas = this.findEl("progress-canvas");
        canvas.width = canvas.height = canvas.style.width = canvas.style.height = this.size;
        this.ctx = canvas.getContext("2d");
        this.ctx.strokeStyle = "#fff";
        return this.ctx.lineWidth = 1.5;
      } catch (_error) {
        e = _error;
      }
    };

    RadialProgressView.prototype.update = function(total, run) {
      var half, percent;
      percent = total ? Math.ceil((run * 100) / total) : 0;
      this.setHtml("progress-percent", percent + "%");
      if (!this.ctx) {
        return;
      }
      half = this.size / 2;
      this.ctx.clearRect(0, 0, this.size, this.size);
      this.ctx.beginPath();
      this.ctx.arc(half, half, half - 1, 0, Math.PI * 2 * (percent / 100), false);
      return this.ctx.stroke();
    };

    return RadialProgressView;

  })(Teaspoon.Reporters.HTML.ProgressView);

}).call(this);
