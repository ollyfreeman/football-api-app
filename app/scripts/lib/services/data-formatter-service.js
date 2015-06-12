(function() {
  angular.module('footballAPI').factory('DataFormatterService', [
    'DATA', 'TIME', function(DATA, TIME) {
      var addEventToGlobalEvents, dataFormatterService, getCurrentResult, getEventTeam, getMatchTime, isSecondHalf;
      dataFormatterService = {};
      dataFormatterService.processRawMatch = function(rawMatch) {
        var formattedMatch;
        formattedMatch = {};
        formattedMatch.home_team = rawMatch.match_localteam_name;
        formattedMatch.away_team = rawMatch.match_visitorteam_name;
        formattedMatch.home_score = 0;
        formattedMatch.away_score = 0;
        formattedMatch.events = [];
        formattedMatch.currentResult = [DATA.DRAW];
        return formattedMatch;
      };
      dataFormatterService.processLiveData = function(dataTime, formattedMatches, globalEvents, rawData) {
        var awayScore, formattedMatch, homeScore, i, j, k, l, m, matchTime, rawEvent, rawEventTime, rawEvents, rawMatch, ref, ref1, ref2, ref3, ref4, ref5;
        for (i = k = 0, ref = formattedMatches.length; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
          rawMatch = rawData.matches[i];
          formattedMatch = formattedMatches[i];
          matchTime = getMatchTime(rawMatch);
          rawEvents = rawMatch.match_events;
          for (j = l = ref1 = formattedMatch.events.length, ref2 = rawEvents.length; ref1 <= ref2 ? l < ref2 : l > ref2; j = ref1 <= ref2 ? ++l : --l) {
            rawEvent = rawEvents[j];
            rawEventTime = parseInt(rawEvent[DATA.EVENT_TIME]);
            if (rawEvent[DATA.EVENT_TYPE] === DATA.EVENT_TYPE_GOAL) {
              ref3 = rawEvent[DATA.EVENT_RESULT].replace('[', '').replace(']', '').split(' - ').map(function(el) {
                return parseInt(el);
              }), homeScore = ref3[0], awayScore = ref3[1];
              formattedMatch.home_score = homeScore;
              formattedMatch.away_score = awayScore;
              formattedMatch.currentResult[rawEventTime] = getCurrentResult(homeScore, awayScore);
            }
            rawEvent[DATA.EVENT_TEAM] = getEventTeam(rawEvent, formattedMatch.home_team, formattedMatch.away_team);
            formattedMatch.events.push(rawEvent);
            addEventToGlobalEvents(rawEvent, matchTime, globalEvents);
          }
          for (j = m = ref4 = dataTime + 1, ref5 = matchTime; ref4 <= ref5 ? m <= ref5 : m >= ref5; j = ref4 <= ref5 ? ++m : --m) {
            if (!formattedMatch.currentResult[j]) {
              formattedMatch.currentResult[j] = formattedMatch.currentResult[j - 1];
            }
          }
        }
        return matchTime;
      };
      getMatchTime = function(rawMatch) {
        var offset;
        if (rawMatch[DATA.MATCH_TIMER] === DATA.MATCH_TIMER_FINISHED) {
          return TIME.SECONDHALF_END;
        } else {
          offset = isSecondHalf(rawMatch) ? TIME.SECONDHALF_START - TIME.FIRSTHALF_END : TIME.FIRSTHALF_START;
          return parseInt(rawMatch[DATA.MATCH_TIMER]) + offset;
        }
      };
      isSecondHalf = function(rawMatch) {
        return (rawMatch[DATA.HT_SCORE] !== DATA.HT_SCORE_NOT_REACHED) && (rawMatch[DATA.MATCH_STATUS] !== DATA.MATCH_STATUS_HT);
      };
      getCurrentResult = function(homeScore, awayScore) {
        var actual, scoreDiff;
        scoreDiff = homeScore - awayScore;
        if (scoreDiff > 0) {
          return actual = DATA.HOME_WIN;
        } else if (scoreDiff < 0) {
          return actual = DATA.AWAY_WIN;
        } else {
          return actual = DATA.DRAW;
        }
      };
      getEventTeam = function(rawEvent, homeTeam, awayTeam) {
        if (rawEvent[DATA.EVENT_TEAM] === DATA.HOME_TEAM) {
          return homeTeam;
        } else {
          return awayTeam;
        }
      };
      addEventToGlobalEvents = function(rawEvent, matchTime, globalEvents) {
        if (!globalEvents[matchTime]) {
          return globalEvents[matchTime] = [rawEvent];
        } else {
          return globalEvents[matchTime].push(rawEvent);
        }
      };
      return dataFormatterService;
    }
  ]);

}).call(this);
