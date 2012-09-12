define([
    'text!templates/header.html'
], function(
    Template
    ){

    views.header = new (Backbone.View.extend({
        el: '.header',
        template: _.template(Template),
        events: {
        },

        // constructor
        initialize: function () {
        },

        render: function () {
            $(this.el).html(this.template());
        },

        selectMenuItem: function (menuItem) {
            $('.nav li').removeClass('active');
            if (menuItem) {
                $('.' + menuItem).addClass('active');
            }
        }
    }));
    return views.header;
});