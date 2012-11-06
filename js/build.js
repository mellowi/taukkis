// node.js
// run in this folder: "node r.js -o app.build.js"
({
  // http://requirejs.org/docs/optimization.html
  appDir: "../",
  baseUrl: "js",
  dir: "../../apps4finlands-build",

  // all shim and path configurations
  mainConfigFile: 'main.js',

  // optimize
  optimize: "uglify",
  
  // remove cs module names
  onBuildWrite: function(moduleName, path, contents) {
    return contents.replace(/cs\!/g, '');
  },

  // Modules to be optimized:
  modules: [
    { 
      name: "main",
      exclude: ['coffee-script'],
    }
  ]
})