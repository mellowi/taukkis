// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["text!templates/information.html", "views/header"], function(Template) {
    var Information;
    Information = (function(_super) {

      __extends(Information, _super);

      function Information() {
        return Information.__super__.constructor.apply(this, arguments);
      }

      Information.prototype.el = "#information";

      Information.prototype.template = _.template(Template);

      Information.prototype.events = {
        "tap .category-filter": "categories"
      };

      Information.prototype.render = function() {
        views.header.render(this.el);
        return $("#" + this.el.id + " div[data-role='content']").html(this.template());
      };

      Information.prototype.categories = function(e) {
        return utils.setCategory(e);
      };

      return Information;

    })(Backbone.View);
    return views.information = new Information;
  });

}).call(this);
