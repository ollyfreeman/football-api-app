(function() {
  angular.module('footballAPI').controller('MatchController', [
    'DataService', '$http', '$interval', 'DATA', 'GRAPH', 'TIME', function(DataService, $http, $interval, DATA, GRAPH, TIME) {
      var addEventTooltip, addPredictionTooltip, calculatePlayerScore, ctrl, finishSimulation, formatCurrentResults, initaliseEvents, initaliseMatches, initialiseEventTooltips, initialiseGraphData, initialiseGraphLabels, initialisePlayerScore, initialisePredictionTooltips, initialisePredictions, newInterval, recordPrediction;
      ctrl = this;
      ctrl.simulationReady = false;
      ctrl.simulationTime = 0;
      ctrl.matchSpeed = 200;
      ctrl.matches = [];
      ctrl.globalEvents = [];
      ctrl.predictions = [];
      ctrl.predictionTooltips = {};
      ctrl.eventTooltips = {};
      ctrl.playerScore = [];
      ctrl.graphData = [];
      ctrl.graphLabels = [];
      DataService.getInitalMatchInfo().then(function() {
        initaliseMatches();
        initaliseEvents();
        initialisePredictions();
        initialisePredictionTooltips();
        initialiseEventTooltips();
        initialisePlayerScore();
        initialiseGraphData();
        initialiseGraphLabels();
        return ctrl.simulationReady = true;
      }, function() {
        return console.log(':(');
      });
      ctrl.startSimulation = function() {
        var lengthOfSimulatedMinute;
        lengthOfSimulatedMinute = TIME.SIXTY_SECONDS / ctrl.matchSpeed;
        return DataService.startMatch(ctrl.matchSpeed).then(function() {
          var intervalId;
          return intervalId = newInterval(lengthOfSimulatedMinute, function() {
            if (ctrl.simulationTime >= TIME.SECONDHALF_END) {
              finishSimulation(intervalId);
            }
            formatCurrentResults();
            recordPrediction();
            addEventTooltip();
            calculatePlayerScore();
            return ctrl.simulationTime += 1;
          });
        }, function() {
          return console.log(':(');
        });
      };
      ctrl.changePrediction = function(matchIndex) {
        ctrl.predictions[matchIndex].lastChange = ctrl.simulationTime;
        return addPredictionTooltip(matchIndex);
      };

      /*
      Initialisers
       */
      initaliseMatches = function() {
        return ctrl.matches = DataService.matches;
      };
      initaliseEvents = function() {
        return ctrl.globalEvents = DataService.globalEvents;
      };
      initialisePredictions = function() {
        var j, len, match, ref, results;
        ref = ctrl.matches;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          match = ref[j];
          results.push(ctrl.predictions.push({
            current: DATA.DRAW,
            lastChange: TIME.FIRSTHALF_START,
            list: [DATA.DRAW]
          }));
        }
        return results;
      };
      initialisePredictionTooltips = function() {
        var match;
        ctrl.predictionTooltips.list = (function() {
          var j, ref, ref1, results;
          results = [];
          for (j = ref = TIME.FIRSTHALF_START, ref1 = TIME.SECONDHALF_END; ref <= ref1 ? j <= ref1 : j >= ref1; ref <= ref1 ? j++ : j--) {
            results.push(null);
          }
          return results;
        })();
        return ctrl.predictionTooltips.mostRecent = (function() {
          var j, len, ref, results;
          ref = ctrl.matches;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            match = ref[j];
            results.push(null);
          }
          return results;
        })();
      };
      initialiseEventTooltips = function() {
        return ctrl.eventTooltips.list = (function() {
          var j, ref, ref1, results;
          results = [];
          for (j = ref = TIME.FIRSTHALF_START, ref1 = TIME.SECONDHALF_END; ref <= ref1 ? j <= ref1 : j >= ref1; ref <= ref1 ? j++ : j--) {
            results.push(null);
          }
          return results;
        })();
      };
      initialisePlayerScore = function() {
        return ctrl.playerScore = (function() {
          var j, ref, ref1, results;
          results = [];
          for (j = ref = TIME.FIRSTHALF_START, ref1 = TIME.SECONDHALF_END; ref <= ref1 ? j <= ref1 : j >= ref1; ref <= ref1 ? j++ : j--) {
            results.push(0);
          }
          return results;
        })();
      };
      initialiseGraphData = function() {
        return ctrl.graphData.push(ctrl.playerScore);
      };
      initialiseGraphLabels = function() {
        var i, j, k, l, m, ref, ref1, ref10, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, results;
        for (i = j = ref = TIME.FIRSTHALF_START, ref1 = TIME.SECONDHALF_END; ref <= ref1 ? j <= ref1 : j >= ref1; i = ref <= ref1 ? ++j : --j) {
          ctrl.graphLabels.push('');
        }
        for (i = k = ref2 = TIME.FIRSTHALF_START, ref3 = TIME.FIRSTHALF_END - 1, ref4 = GRAPH.LABEL_GAP; ref4 > 0 ? k <= ref3 : k >= ref3; i = k += ref4) {
          ctrl.graphLabels[i] = i + "FH";
        }
        for (i = l = ref5 = TIME.HALFTIME_START, ref6 = TIME.HALFTIME_END, ref7 = GRAPH.LABEL_GAP; ref7 > 0 ? l <= ref6 : l >= ref6; i = l += ref7) {
          ctrl.graphLabels[i] = (i - TIME.HALFTIME_START) + "HT";
        }
        results = [];
        for (i = m = ref8 = TIME.SECONDHALF_START, ref9 = TIME.SECONDHALF_END, ref10 = GRAPH.LABEL_GAP; ref10 > 0 ? m <= ref9 : m >= ref9; i = m += ref10) {
          results.push(ctrl.graphLabels[i] = (i - (TIME.SECONDHALF_START - TIME.FIRSTHALF_END)) + "SH");
        }
        return results;
      };

      /*
      startSimulation helper methods
       */
      newInterval = function(interval, callback) {
        return $interval(callback, interval);
      };
      finishSimulation = function(intervalId) {
        $interval.cancel(intervalId);
        return console.log('Match Finished.');
      };
      addEventTooltip = function() {
        var event, eventString, eventTooltipString, j, len, ref;
        if (ctrl.globalEvents[ctrl.simulationTime]) {
          eventTooltipString = '';
          ref = ctrl.globalEvents[ctrl.simulationTime];
          for (j = 0, len = ref.length; j < len; j++) {
            event = ref[j];
            eventString = event.event_team + " - " + event.event_type + " - " + event.event_player + " - " + event.event_minute;
            eventTooltipString += eventString + " ---";
          }
          return ctrl.eventTooltips.list[ctrl.simulationTime] = eventTooltipString;
        }
      };
      calculatePlayerScore = function() {
        var finalNumberOfPredictions, i, j, match, numberOfMatches, prediction, predictionWasCorrect, ref, totalScore;
        totalScore = 0;
        numberOfMatches = ctrl.matches.length;
        finalNumberOfPredictions = TIME.SECONDHALF_END + 1;
        for (i = j = 0, ref = numberOfMatches; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          prediction = ctrl.predictions[i];
          match = ctrl.matches[i];
          predictionWasCorrect = prediction.list[ctrl.simulationTime] === match.currentResult[ctrl.simulationTime];
          totalScore += ((finalNumberOfPredictions - prediction.lastChange) / finalNumberOfPredictions) * predictionWasCorrect;
        }
        return ctrl.playerScore[ctrl.simulationTime] = totalScore / numberOfMatches;
      };
      formatCurrentResults = function() {
        var j, len, match, ref, ref1, results;
        ref = ctrl.matches;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          match = ref[j];
          if ((TIME.HALFTIME_START <= (ref1 = ctrl.simulationTime) && ref1 <= TIME.HALFTIME_END)) {
            results.push(match.currentResult[ctrl.simulationTime] = match.currentResult[ctrl.simulationTime - 1]);
          } else {
            results.push(void 0);
          }
        }
        return results;
      };
      recordPrediction = function() {
        var j, len, prediction, ref, results;
        ref = ctrl.predictions;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          prediction = ref[j];
          results.push(prediction.list[ctrl.simulationTime] = angular.copy(prediction.current));
        }
        return results;
      };

      /*
      other helper methods
       */
      addPredictionTooltip = function(matchIndex) {
        var i, j, match, predictionTooltipString, ref;
        match = ctrl.matches[matchIndex];
        predictionTooltipString = match.home_team + " " + match.home_score + " - " + match.away_score + " " + match.away_team + "\n    " + ctrl.predictions[matchIndex].current + " (" + ctrl.simulationTime + " mins).";
        ctrl.predictionTooltips.mostRecent[matchIndex] = predictionTooltipString;
        if (ctrl.predictionTooltips.list[ctrl.simulationTime] === null) {
          return ctrl.predictionTooltips.list[ctrl.simulationTime] = predictionTooltipString;
        } else {
          predictionTooltipString = '';
          for (i = j = 0, ref = ctrl.matches.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
            if (ctrl.predictions[i].lastChange === ctrl.simulationTime) {
              predictionTooltipString += ctrl.predictionTooltips.mostRecent[i] + " --- ";
            }
          }
          return ctrl.predictionTooltips.list[ctrl.simulationTime] = predictionTooltipString;
        }
      };

      /*
      return the controller
       */
      return ctrl;
    }
  ]);

}).call(this);
