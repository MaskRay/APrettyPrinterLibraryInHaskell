module.exports = (grunt) ->
  'use strict'

  grunt.initConfig
    coffee:
      debug:
        files: [
          expand: true
          cwd: 'js'
          src: ['**/*.coffee', '!**/_*.coffee']
          dest: 'js'
          ext: '.js'
        ]

    stylus:
      debug:
        files: [
          expand: true
          cwd: 'css'
          src: ['**/*.styl', '!**/_*.styl']
          dest: 'css'
          ext: '.css'
        ]

    jade:
      debug:
        files: [
          expand: true
          src: ['*.jade', '!_*.jade']
          ext: '.html'
        ]

    watch:
      coffee:
        files: ['js/**/*.coffee']
        tasks: ['coffee']

      stylus:
        files: ['css/**/*.styl']
        tasks: ['stylus']

      jade:
        files: ['*.jade']
        tasks: ['jade']

    clean:
      dev: ['*.html', 'css/style.css']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'debug', ['coffee:debug', 'stylus:debug', 'jade:debug']
  grunt.registerTask 'dev', ['debug', 'watch']
