define([
    'models/model', 
    'text!templates/home.html'
], function(
    Model, 
    Template
    ){

    views.home = new (Backbone.View.extend({
        el: '#content',
        template: _.template(Template),
        events: {
        },

        // constructor
        initialize: function() {
            this.model = new Model();
        },

        render: function() {
            $(this.el).html(this.template({ 
                model: this.model.toJSON()
            }));
        }
    }));
    return views.home;
});