module.exports = (grunt) ->

    grunt.initConfig {
        # to allow importing data from package.json
        pkg: grunt.file.readJSON('package.json')

        watch: {
          scripts: {
            files: ['**/*.coffee', 'etc/**']
            tasks: ['default']
            options: {
              spawn: true
            }
          }
        }

        coffeelint: {
            app: ['./app/scripts/src/**/*.coffee']
            options: {
                configFile: './coffeelint.json'
            }
        }

        coffee: {
            glob_to_multiple: {
                expand: true
                flatten: false
                cwd: 'app/scripts/src'
                src: ['**/*.coffee']
                dest: 'app/scripts/lib'
                ext: '.js'
            }
        }

        concat: {
            options: {
                separator: ';\n'
            },
            dist: {
                src: [
                    './bower_components/angular/angular.min.js',
                    './bower_components/Chart.js/Chart.min.js',
                    './bower_components/angular-aria/angular-aria.min.js',
                    './bower_components/angular-animate/angular-animate.min.js',
                    './bower_components/angular-chart.js/dist/angular-chart.min.js',
                    './bower_components/angular-material/angular-material.min.js',
                    './bower_components/angular-sanitize/angular-sanitize.min.js',
                    './vendors/markdown.js',
                    './app/scripts/lib/**/*.js'
                ],
                dest: './app/scripts/football-api-app.js'
            }
        }

        uglify: {
            options: {
                mangle: false
            }
            dist: {
                files: {
                    './app/scripts/football-api-app.min.js': ['./app/scripts/football-api-app.js']
                }
            }
        }
    }

    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-coffeelint')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-contrib-uglify')

    grunt.registerTask('default', ['coffeelint', 'coffee'])
