module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'

        watch:
            scripts:
                files: [
                    './scripts/coffee/**/*.coffee'
                    './styles/scss/**/*.scss'
                    './html/**/*.html'
                    './img/*'
                ]
                tasks: ['default']
                options:
                    spawn: false

        coffeelint:
            app: ['./scripts/coffee/**/*.coffee']
            options:
                configFile: './coffeelint.json'

        coffee:
            glob_to_multiple:
                expand: true
                flatten: false
                cwd: 'scripts/coffee'
                src: ['./**/*.coffee']
                dest: 'scripts/js'
                ext: '.js'

        sass:
            options:
                outputStyle: 'expanded'
            dist:
                files:
                    './styles/css/main.css': './styles/scss/main.scss'

        copy:
            generated:
                src: './html/index.html'
                dest: './index.html'

        useminPrepare:
            html: './index.html'
            options:
                dest: './'

        cssmin :
            options:
                keepSpecialComments: 0

        usemin:
            html: ['./index.html']

        clean:
            tmp: ['./.tmp']
            all: [
                './scripts/js'
                './scripts/dist'
                './styles/css'
                './styles/dist'
                './index.html'
                './.tmp'
            ]


    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-sass'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-usemin'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-clean'


    # register grunt tasks according to environment variable
    environment = grunt.config.data.pkg.env or process.env.GRUNT_ENV or 'development'
    if environment is 'development'
        grunt.registerTask 'default', [
            'coffeelint'
            'coffee'
            'sass'
            'copy'
        ]
    else if environment is 'production'
        grunt.registerTask 'default', [
            'coffeelint'
            'coffee'
            'sass'
            'copy'
            'useminPrepare'
            'concat'
            'uglify'
            'cssmin'
            'usemin'
            'clean:tmp'
        ]
    else
        console.log "environment variable '#{environment}' is not valid - no grunt tasks were run\n"
        grunt.registerTask 'default', []