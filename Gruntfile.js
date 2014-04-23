module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    jshint: {
      all: ['Gruntfile.js', 'jasmine/**/*js'],
      options: {
        '-W051': 'ignores variable deletion warning',
        '-W014': 'ignores "Bad line breaking" errors, for comma-first style',
        ignores: ['jasmine/support/*.js']
      }
    },

    watch: {
      files: ['Gruntfile.js', 'jasmine/**/*js'],
      tasks: ['jshint', 'jasmine']
    },

    jasmine: {
      files: ['jasmine/**/*js'],
      options: {
        vendor: ['jasmine/support/*.js']
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['jshint', 'jasmine']);
};
