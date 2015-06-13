(function() {
  angular.module('footballAPI').factory('Data', [
    'DataFormatter', '$http', '$interval', '$q', '$timeout', 'TIME', 'URL', function(DataFormatter, $http, $interval, $q, $timeout, TIME, URL) {
      var dataService, executeAndNewInterval, stopFetching;
      dataService = {};
      dataService.time = TIME.INITIAL_TIME;
      dataService.matches = [];
      dataService.globalEvents = [];
      dataService.getInitalMatchInfo = function() {
        return $q(function(resolve, reject) {
          return $http.get(URL.GET_INITIAL_MATCH_INFO).success(function(data, status) {
            var i, len, match;
            for (i = 0, len = data.length; i < len; i++) {
              match = data[i];
              dataService.matches.push(DataFormatter.processRawMatch(match));
            }
            return resolve();
          }).error(function(data, status) {
            return reject();
          });
        });
      };
      dataService.startMatch = function(matchSpeed) {
        var lengthOfSimulatedMinute, startSimulationURL;
        lengthOfSimulatedMinute = TIME.SIXTY_SECONDS / matchSpeed;
        startSimulationURL = "" + URL.START_SIMULATON_PREFIX + matchSpeed;
        return $q(function(resolve, reject) {
          return $http.get(startSimulationURL).success(function(data, status) {
            var getSimulationUpdateURL, intervalId, tokenId;
            tokenId = data.tokenId;
            getSimulationUpdateURL = "" + URL.GET_SIMULATON_UPDATE_PREFIX + tokenId;
            return intervalId = executeAndNewInterval(lengthOfSimulatedMinute, function() {
              return $http.get(getSimulationUpdateURL).success(function(data, status) {
                dataService.time = DataFormatter.processLiveData(dataService.time, dataService.matches, dataService.globalEvents, data);
                resolve();
                if (dataService.time >= TIME.SECONDHALF_END) {
                  return stopFetching(intervalId);
                }
              }).error(function(data, status) {
                stopFetching(intervalId);
                return reject();
              });
            });
          }).error(function(data, status) {
            return reject();
          });
        });
      };
      executeAndNewInterval = function(interval, callback) {
        callback();
        return $interval(callback, interval);
      };
      stopFetching = function(intervalId) {
        return $interval.cancel(intervalId);
      };
      return dataService;
    }
  ]);

}).call(this);
