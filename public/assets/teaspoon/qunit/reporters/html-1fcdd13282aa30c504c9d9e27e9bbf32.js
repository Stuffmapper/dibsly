(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Teaspoon.Reporters.HTML = (function(superClass) {
    extend(HTML, superClass);

    function HTML(env) {
      this.reportRunnerResults = bind(this.reportRunnerResults, this);
      this.reportSpecResults = bind(this.reportSpecResults, this);
      HTML.__super__.constructor.apply(this, arguments);
      env.log(this.reportSpecResults);
      env.testDone(this.reportSpecResults);
      env.done(this.reportRunnerResults);
      this.currentAssertions = [];
      this.reportRunnerStarting();
    }

    HTML.prototype.reportRunnerStarting = function() {
      this.total.exist = null;
      return this.setText("stats-duration", "...");
    };

    HTML.prototype.reportSpecResults = function(spec) {
      if (typeof spec.total !== "number") {
        this.currentAssertions.push(spec);
        return;
      }
      spec.assertions = this.currentAssertions;
      this.currentAssertions = [];
      this.reportSpecStarting(spec);
      return HTML.__super__.reportSpecResults.call(this, spec);
    };

    HTML.prototype.reportRunnerResults = function(result) {
      this.total.exist = this.total.run = result.total;
      return HTML.__super__.reportRunnerResults.apply(this, arguments);
    };

    HTML.prototype.readConfig = function() {
      HTML.__super__.readConfig.apply(this, arguments);
      return QUnit.config.notrycatch = this.config["use-catch"];
    };

    HTML.prototype.envInfo = function() {
      return "qunit " + (_qunit_version || "[unknown version]");
    };

    return HTML;

  })(Teaspoon.Reporters.HTML);

  Teaspoon.Reporters.HTML.SpecView = (function(superClass) {
    extend(SpecView, superClass);

    function SpecView() {
      return SpecView.__super__.constructor.apply(this, arguments);
    }

    SpecView.prototype.buildErrors = function() {
      var div, error, html, i, len, ref;
      div = this.createEl("div");
      html = "";
      ref = this.spec.errors();
      for (i = 0, len = ref.length; i < len; i++) {
        error = ref[i];
        html += "<strong>" + error.message + "</strong><br/>" + (this.htmlSafe(error.stack || "Stack trace unavailable")) + "<br/>";
      }
      div.innerHTML = html;
      return this.append(div);
    };

    SpecView.prototype.buildParent = function() {
      var parent, view;
      parent = this.spec.parent;
      if (!parent) {
        return this.reporter;
      }
      if (this.views.suites[parent.description]) {
        return this.views.suites[parent.description];
      } else {
        view = new Teaspoon.Reporters.HTML.SuiteView(parent, this.reporter);
        return this.views.suites[parent.description] = view;
      }
    };

    return SpecView;

  })(Teaspoon.Reporters.HTML.SpecView);

  Teaspoon.Reporters.HTML.FailureView = (function(superClass) {
    extend(FailureView, superClass);

    function FailureView() {
      return FailureView.__super__.constructor.apply(this, arguments);
    }

    FailureView.prototype.build = function() {
      var error, html, i, len, ref;
      FailureView.__super__.build.call(this, "spec");
      html = "<h1 class=\"teaspoon-clearfix\"><a href=\"" + this.spec.link + "\">" + (this.htmlSafe(this.spec.fullDescription)) + "</a></h1>";
      ref = this.spec.errors();
      for (i = 0, len = ref.length; i < len; i++) {
        error = ref[i];
        html += "<div><strong>" + error.message + "</strong><br/>" + (this.htmlSafe(error.stack || "Stack trace unavailable")) + "</div>";
      }
      return this.el.innerHTML = html;
    };

    return FailureView;

  })(Teaspoon.Reporters.HTML.FailureView);

  Teaspoon.Reporters.HTML.SuiteView = (function(superClass) {
    extend(SuiteView, superClass);

    function SuiteView(suite, reporter) {
      this.suite = suite;
      this.reporter = reporter;
      this.views = this.reporter.views;
      this.views.suites[this.suite.description] = this;
      this.build();
    }

    return SuiteView;

  })(Teaspoon.Reporters.HTML.SuiteView);

}).call(this);
