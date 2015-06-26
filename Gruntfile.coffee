module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'

        watch:
            dev:
                files: [
                    './scripts/coffee/**/*.coffee'
                    './styles/scss/**/*.scss'
                    './html/**/*.html'
                    './img/*'
                ]
                tasks: ['build:development']
                options:
                    spawn: false
            prod:
                files: [
                    './scripts/coffee/**/*.coffee'
                    './styles/scss/**/*.scss'
                    './html/**/*.html'
                    './img/*'
                ]
                tasks: ['build:production']
                options:
                    spawn: false

        githooks:
            all:
                'pre-commit' : 'npm run build'
            options:
                template : './etc/githooks/pre-commit.js'

        coffeelint:
            app: ['./scripts/coffee/**/*.coffee']
            options:
                configFile: './etc/coffeelint.json'

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
                './etc/githooks/js'
                './index.html'
                './.tmp'
            ]

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-githooks'

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-sass'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-usemin'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-clean'

    grunt.registerTask 'build:development', [
        'coffeelint'
        'coffee'
        'sass'
        'copy'
    ]

    grunt.registerTask 'build:production', [
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