module.exports = (grunt) ->

    grunt.initConfig {
        # to allow importing data from package.json
        pkg: grunt.file.readJSON('package.json')

        coffeelint: {
            app: ['./app/*.coffee', './test/*.coffee']
            options: {
                configFile: './coffeelint.json'
            }
        }

        coffee: {
            glob_to_multiple: {
                expand: true
                flatten: false
                cwd: 'app/src'
                src: ['**/*.coffee']
                dest: 'app/lib'
                ext: '.js'
            }
        }

        watch: {
          scripts: {
            files: ['**/*.coffee', 'etc/**']
            tasks: ['default']
            options: {
              spawn: true
            }
          }
        }
    }

    grunt.loadNpmTasks('grunt-coffeelint')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')

    grunt.registerTask('default', ['coffeelint', 'coffee'])
