// node.js
// run in this folder: "node r.js -o app.build.js"
({
  // http://requirejs.org/docs/optimization.html
  appDir: "../",
  baseUrl: "js",
  dir: "../../backbone-build",

  // all shim and path configurations
  mainConfigFile: 'main.js',

  // optimize
  optimize: "uglify",
  
  // Modules to be optimized:
  modules: [
    { name: "main" },
  ]
})