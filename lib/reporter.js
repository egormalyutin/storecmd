// Generated by CoffeeScript 2.0.2
module.exports = {
  creating: function(dir) {
    return console.log(`Database ${dir} not found! Creating a new one...`);
  },
  loading: function(dir) {
    return console.log(`Database ${dir} found! Reading it...`);
  }
};