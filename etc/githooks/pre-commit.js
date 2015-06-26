exec = require('child_process').exec

exec('{{task}}', function(err, stdout, stderr) {

    console.log(stdout);

    var exitCode;
    if (err) {
        exitCode = -1;
    } else {
        exitCode = 0;
    }

      return process.exit(exitCode);
});