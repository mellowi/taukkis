define([], function(){
    router = new (Backbone.Router.extend({
        initialize: function(){
            // Tells Backbone to start watching for hashchange events
            Backbone.history.start();
            require(['views/header'], function(){
                views.header.render();
            });
        },

        routes: {
            // When there is no hash bang on the url, the home method is called
            '': 'home',
            'home': 'home',
        },

        'home': function(){
            require(['views/home'], function(){
                views.home.render();
            });
        }
    }));
});